const { v4: uuidv4 } = require('uuid');

const item = {
    "_id": "my-id",
    "role": "covid_contact", //<mandatory>
    "case_id": "245",
    "case_name": "Antony",
    "type_of_contact": "2", //<mandatory>
    "relation_to_case": "spouse",
    "national_id": "0078243",
    "passport_number": "",
    "alien_number": "",
    "s_name": "Khaemba", //<mandatory>
    "f_name": "Grace", //<mandatory>
    "o_name": "",
    "name": "Grace  Khaemba", //<mandatory>
    "sex": "female", //<mandatory>
    "dob_known": "no",
    "date_of_birth": "1990-04-21", //<mandatory>
    "marital_status": "married_monogamous",
    "head_of_household": "no",
    "date_of_last_contact": "2020-04-20", //<mandatory>
    "occupation": "other",
    "occupation_other": "Farmer",
    "health_care_worker": "yes",
    "facility": "Bungoma West Hospital",
    "education": "primary_school_education",
    "deceased": "no", //<mandatory>
    "nationality": "kenya",
    "phone": "+254721000000",
    "alternate_phone": "",
    "postal_address": "",
    "email_address": "",
    "county": "bungoma",
    "subcounty": "mt_elgon",
    "ward": "",
    "location": "",
    "sub_location": "",
    "village": "",
    "landmark": "",
    "residence": "",
    "nearest_health_center": "",
    "kin_name": "Simon",
    "kin_relationship": "father",
    "kin_phone_number": "",
    "kin_postal_address": ""
};

const extractContactDetails = item => {
    const contact = {
        _id: uuidv4(),
        type: 'contact',
        contact_type: 'trace_case_contact'
    };
    const excludedKeys = ['_id', '_rev', 'needs_sign_off', 'place_id', 'patient_id', 'contacts', 'parent']
    for (const key of Object.keys(item)) {
        if (!excludedKeys.includes(key) && !!item[key]) {
            contact[key] = item[key];
        }
    }
    return contact;
};
console.log(`${'_id' in ['_id', '_rev', 'needs_sign_off', 'place_id', 'patient_id', 'contacts', 'parent']}`);
console.log(extractContactDetails(item)._id, item._id)
