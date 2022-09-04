const { URL } = require('url');
const level = require('level');
const { v4: uuidv4 } = require('uuid');
const PouchDB = require('pouchdb-core');

PouchDB.plugin(require('pouchdb-adapter-http'));
PouchDB.plugin(require('pouchdb-mapreduce'));

const CONTACT_TYPES = {
  case: 'trace_case',
  suspected_case: 'suspected_case',
  national_office: 'anational_office',
  forwarded_case: 'forwarded_case',
  contact: 'trace_contact'
};

const CHANGES_LIMIT = 100;
const SLEEP_DELAY = 1000;
const EXCLUDED_KEYS = ['_id', '_rev', 'needs_sign_off', 'place_id', 'patient_id', 'parent', 'type', 'contact_type'];

if (!process.env.COUCH_URL) {
  throw new Error('COUCH_URL env var not set.');
}

const cache = level('cache');


let COUCH_URL;
try {
  COUCH_URL = new URL(process.env.COUCH_URL);

  if (COUCH_URL.pathname !== '/medic') {
    COUCH_URL.pathname = '/medic';
  }
} catch (err) {
  console.error(`You need to define a valid COUCH_URL`);
  console.error(err.stack);
  console.error('Exiting');
  process.exit(-1);
}

const couchdb = new PouchDB(COUCH_URL.href);

const getUTCTimestamp = () => new Date(Date.now() + (new Date().getTimezoneOffset() * 60000)).getTime();

const getChangesAndLastSeq = async (db, seqNumber) => {
  const changes = await db.changes({ limit: CHANGES_LIMIT, since: seqNumber });
  return {
    changeSet: changes.results.filter(change => !change.deleted),
    seqNumber: changes.last_seq
  };
};

const getCase = async (db, type, keyField, key) => {
  let response;
  let result;

  const options = {
    include_docs: true,
  };

  if (keyField === '_id') {
    options.keys = [key];
    response = await db.allDocs(options);
  } else {
    options.key = [`${type}`, `${keyField}:${key}`];
    response = await db.query('medic-client/contacts_by_type_freetext', options);
  }

  response.rows.forEach(row => {
    if (row.doc && row.doc.contact_type === type) {
      result = row.doc;
    }
  });

  return result;
};

const getPlacesByType = async (db, placeType) => {
  const options = {
    include_docs: true,
    key: [`${placeType}`],
  };

  const docs = await db.query('medic-client/contacts_by_type', options);

  const result = [];
  docs.rows.map(row => {
    if (row.doc) {
      result.push(row.doc);
    }
  });
  return result;
};

const getDocsFromChangeSet = async (db, changeSet) => {
  const options = {
    include_docs: true,
    keys: changeSet.map(change => change.id)
  };
  const docs = await db.allDocs(options);
  const result = [];
  docs.rows.map(row => {
    if (row.doc) {
      result.push(row.doc);
    }
  });
  return result;
};

const getDocsMap = async (db, docs) => {
  const options = {
    include_docs: false,
    keys: docs.map((doc) => doc._id)
  };

  const result = {};
  const response = await db.allDocs(options);

  response.rows.forEach((row) => {
    if (row.doc) {
      result[row.doc._id] = row.doc;
    }
  });

  return result;
};

const getSeqNumber = async cache => {
  let seqNumber;
  try {
    seqNumber = await cache.get('seqNumber');
  } catch (err) {
    seqNumber = '0';
  }
  return seqNumber;
};

const updateSeqNumber = async (cache, seqNumber) => {
  try {
    await cache.put('seqNumber', seqNumber);
  } catch (err) {
    console.error('Error updating the most recent Sequence Number');
    console.error(err.stack);
    throw err;
  }
};

const createNewCaseDocument = item => {
  const newCase = {
    _id: uuidv4(),
    kemr_uuid: item._id,
    type: 'contact',
    contact_type: 'forwarded_case',
    reported_date: item.reported_date
  };
  for (const key of Object.keys(item.fields)) {
    if (!EXCLUDED_KEYS.includes(key) && !!item.fields[key]) {
      newCase[key] = item.fields[key];
    }
  }

  if (!newCase.case_name) {
    newCase.case_name = [newCase.f_name, newCase.s_name, newCase.o_name].join(' ').replace(/\s+/, ' ');
  }

  newCase['contacts'] = item.contacts;
  return newCase;
};

const extractContactDetails = (item, retainReference) => {
  const contact = {
    _id: uuidv4(),
    type: 'contact',
    contact_type: 'trace_contact'
  };
  for (const key of Object.keys(item)) {
    if (![...EXCLUDED_KEYS, 'contacts'].includes(key) && !!item[key]) {
      contact[key] = item[key];
    }
    if (retainReference) {
      contact._id = item._id;
    }
  }
  return contact;
};

// adapted from medic-conf
const minifyLineage = lineage => {
  if (!lineage || !lineage._id) {
    return undefined;
  }

  const result = {
    _id: lineage._id,
    parent: minifyLineage(lineage.parent),
  };

  return JSON.parse(JSON.stringify(result));
};

const logPouchDBResults = results => {
  for (const result of results) {
    if (result.ok) {
      console.info(`Doc: ${result.id} saved successfully`);
    } else {
      console.error(`An error occurred while saving Doc: ${result.id}. Error: ${result.error}. Status: ${result.status}`);
    }
  }
};

const moveCasesToCounty = async (db, newCases, counties) => {
  const nationalOffice = (await getPlacesByType(couchdb, CONTACT_TYPES.national_office))[0];

  newCases.forEach(async item => {
    const cases = {};
    cases.existingCase = await getCase(db, CONTACT_TYPES.case, 'kemr_uuid', item._id);
    cases.forwardedCase = await getCase(db, CONTACT_TYPES.forwarded_case, 'kemr_uuid', item._id);
    cases.suspectedCase = await getCase(db, CONTACT_TYPES.suspected_case, '_id', item.fields.cht_ref_uuid);
    cases.transitionedSuspectedCase = await getCase(db, CONTACT_TYPES.case, '_id', item.fields.cht_ref_uuid);
    cases.transitionedContact = await getCase(db, CONTACT_TYPES.contact, '_id', item.fields.cht_ref_uuid);

    const docsToCreate = [];
    /*
     When we transition suspected cases to confirmed cases, we'll change it's contact type
     to trace_case from suspected_case. When looking them up after the transition, we still need to rely
     on KenyaEMRs='s cht_ref_uuid attribute.
    */
    const existingCase = cases.existingCase || cases.transitionedSuspectedCase;
    const forwardedCase = cases.forwardedCase;
    const suspectedCase = cases.suspectedCase;
    const covidCase = existingCase || forwardedCase || suspectedCase;
    const existingCaseType = (covidCase || {}).contact_type;
    const newCase = createNewCaseDocument(item);

    //delete report from EMR
    docsToCreate.push({ _id: item._id, _rev: item._rev, _deleted: true });

    if (!existingCaseType) {
      let parent;

      if (cases.transitionedContact) {
        // parent new case to the contact's grand parent
        parent = cases.transitionedContact.parent.parent;
        // change contact type
        newCase.contact_type = CONTACT_TYPES.case;

        // for contacts that become cases
        const contact = Object.assign({}, cases.transitionedContact);
        contact.transitioned_to_case = newCase._id;
        contact.muted = true;
        docsToCreate.push(contact);

      } else {
        const countyMatcher = new RegExp(newCase.county || 'xyz-sentinel', 'i');
        parent = counties.filter(county => countyMatcher.test(county.name))[0];

        if (!parent || !newCase.county) {
          console.warn(`No matching county found for Case with KenyaEMR Reference: ${item._id}. Assigning to National Office.`);
          parent = nationalOffice;
        }
      }

      newCase.parent = minifyLineage({ _id: parent._id, parent: parent.parent });

      docsToCreate.push(newCase);

      console.info(`Effecing move for Case ID: <${newCase._id}> KEMR REF: <${newCase.kemr_uuid}> to <${parent.name}>`);
      const results = await db.bulkDocs(docsToCreate);
      logPouchDBResults(results);

    } else if ([CONTACT_TYPES.case, CONTACT_TYPES.suspected_case].includes(existingCaseType)) {
      console.info(`Found case ${covidCase._id} for KenyaEMR Reference: ${item._id}`);
      const contactLineage = minifyLineage(Object.assign({}, { _id: covidCase._id, parent: covidCase.parent }));

      if (newCase.contacts && newCase.contacts.length > 0) {
        // find if these contacts exist
        const idMap = await getDocsMap(db, newCase.contacts);

        newCase.contacts.forEach(newContact => {
          const contact = extractContactDetails(newContact, true);
          contact.parent = contactLineage;
          if (existingCaseType === CONTACT_TYPES.suspected_case) {
            contact.kemr_uuid = item._id; // use KenyaEMR's _id
          } else {
            contact.kemr_uuid = covidCase.kemr_uuid;
          }

          if (!idMap[contact._id]) {
            docsToCreate.push((contact));
            docsToCreate.push(createMutingDocument(contact));
          }
        });
      }
      if (existingCaseType === CONTACT_TYPES.suspected_case && !covidCase.kemr_uuid) {
        covidCase.kemr_uuid = item._id;
        covidCase.contact_type = CONTACT_TYPES.case;
        covidCase.transitioned_on = getUTCTimestamp();
        docsToCreate.push(covidCase);
      }

      if (docsToCreate) {
        const results = await db.bulkDocs(docsToCreate);
        logPouchDBResults(results);
      }
    } else if (existingCaseType === CONTACT_TYPES.forwarded_case) {
      console.info(`Found forwarded case ${covidCase._id} for KenyaEMR Reference: ${item._id}`);

      for (const contact of newCase.contacts) {
        covidCase.contacts.push(contact);
      }

      if (newCase.contacts) {
        docsToCreate.push(covidCase);
      }
      const results = await db.bulkDocs(docsToCreate);
      logPouchDBResults(results);
    }
  });
};

const createMutingDocument = item => {
  return {
    _id: uuidv4(),
    fields: {
      patient_id: item._id,
      reported_date: getUTCTimestamp()
    },
    type: 'data_record',
    content_type: 'xml',
    form: 'trigger_muting',
    reported_date: getUTCTimestamp(),
  };
};

const effectAssignmentOfCases = async (db, cases) => {
  cases.forEach(async item => {
    const docsToCreate = [];
    if (!item.assignee) {
      console.warn(`Case ID: <${item._id}> KEMR REF: <${item.kemr_uuid}> Case Name: <${item.name}> not yet assined to a tracer`);
      return;
    }

    // delete the case we are moving
    docsToCreate.push({ _id: item._id, _rev: item._rev, _deleted: true });

    // get new parent
    const parentPlace = await db.get(item.assignee);
    const caseLineage = minifyLineage(Object.assign({}, { _id: parentPlace._id, parent: parentPlace.parent }));

    const allocatedCovidCase = {
      _id: uuidv4(),
      case_id: item.case_id,
      name: item.name,
      kemr_uuid: item.kemr_uuid,
      county: item.county,
      sub_county: item.subcounty,
      parent: caseLineage,
      type: 'contact',
      contact_type: 'trace_case',
      reported_date: item.reported_date,
    };

    const contactLineage = Object.assign({}, { _id: allocatedCovidCase._id, parent: caseLineage });

    docsToCreate.push(allocatedCovidCase);

    item.contacts.forEach(contactData => {
      const contact = extractContactDetails(contactData, true);
      contact.parent = contactLineage;
      contact.kemr_uuid = allocatedCovidCase.kemr_uuid;
      docsToCreate.push(contact);
    });
    docsToCreate.push(createMutingDocument(allocatedCovidCase));

    if (docsToCreate.length > 0) {
      console.info(`Effecting assignment of Case: ${allocatedCovidCase._id} with KEMR Reference: ${allocatedCovidCase.kemr_uuid}`);
      const results = await db.bulkDocs(docsToCreate);
      logPouchDBResults(results);
    }
  });
};

const updater = async () => {
  let DELAY_FACTOR = 1;
  const seqNumber = await getSeqNumber(cache);
  const counties = await getPlacesByType(couchdb, 'county_office');

  console.info(`Processing from Sequence Number: ${seqNumber.substring(0, 61)}`);

  const result = await getChangesAndLastSeq(couchdb, seqNumber);
  const docs = await getDocsFromChangeSet(couchdb, result.changeSet);

  const casesFromKEMR = docs.filter(doc => doc.type === 'data_record' && doc.form === 'case_information');
  await moveCasesToCounty(couchdb, casesFromKEMR, counties);

  const casesToAllocate = docs.filter(doc => doc.type === 'contact' && doc.contact_type === 'forwarded_case');
  await effectAssignmentOfCases(couchdb, casesToAllocate);
  await updateSeqNumber(cache, result.seqNumber);

  if (seqNumber === result.seqNumber) {
    DELAY_FACTOR = 30;
  } else {
    DELAY_FACTOR = 1;
  }

  return new Promise(() => setTimeout(updater, DELAY_FACTOR * SLEEP_DELAY));
};

(async () => {
  updater();
})();
