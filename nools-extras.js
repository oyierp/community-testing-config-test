const allCovidTested = (contact) => { 
  return contact.reports.some(report => report.form === 'case_investigation' && report.fields.testing && report.fields.testing.cov_test);
};
const posCovidTested = (contact) => {
  return contact.reports.some(report => report.form === 'case_investigation' && report.fields.testing && report.fields.testing.cov_test === 'Positive');
};

const negCovidTested = (contact) => {
  return contact.reports.some(report => report.form === 'case_investigation' && report.fields.testing && report.fields.testing.cov_test === 'Negative');
};

const pendCovidTested = (contact) => {
  return contact.reports.some(report => report.form === 'case_investigation' && report.fields.testing && report.fields.testing.cov_test === 'Pending');
};

const incCovidTested = (contact) => {
  return contact.reports.some(report => report.form === 'case_investigation' && report.fields.testing && report.fields.testing.cov_test === 'Inconclusive' );
};

const emptCovidTested = (contact) => {
  return contact.reports.some(report => report.form === 'case_investigation' && report.fields.testing && report.fields.testing.cov_test === null);
};

const mksCovidTested = (contact) => {
  return contact.parent && 
    contact.reports.some(report => (report.form === 'case_investigation' && report.contact.parent && report.contact.parent._id === 'a422212c-35c8-41c7-a84e-4539ddd5b722') && report.fields.testing && report.fields.testing.cov_test);
};

const kjdCovidTested = (contact) => {
  return contact.parent && 
    contact.reports.some(report => (report.form === 'case_investigation' && report.contact.parent && report.contact.parent._id === '76be1173-24ce-44f6-a9ec-8b1451b266d2') && report.fields.testing && report.fields.testing.cov_test);
};

const nrbCovidTested = (contact) => {
  return contact.parent && 
    contact.reports.some(report => (report.form === 'case_investigation' && report.contact.parent && report.contact.parent._id === 'a7eb19a2-5d1d-4205-9e85-931ba0a32ffe') && report.fields.testing && report.fields.testing.cov_test);
};

const msaCovidTested = (contact) => {
  return contact.parent && 
    contact.reports.some(report => (report.form === 'case_investigation' && report.contact.parent && report.contact.parent._id === '83bd1210-1a73-47d2-9f91-7c4f47bc9061') && report.fields.testing && report.fields.testing.cov_test);
};

const posCovidTestedMks = (contact) => {
  return contact.parent && 
    contact.reports.some(report => (report.form === 'case_investigation' && report.contact.parent && report.contact.parent._id === 'a422212c-35c8-41c7-a84e-4539ddd5b722') && report.fields.testing && report.fields.testing.cov_test ==='Positive');
};

const posCovidTestedKjd = (contact) => {
  return contact.parent && 
    contact.reports.some(report => (report.form === 'case_investigation' && report.contact.parent && report.contact.parent._id === '76be1173-24ce-44f6-a9ec-8b1451b266d2') && report.fields.testing && report.fields.testing.cov_test ==='Positive');
};

const posCovidTestedNrb = (contact) => {
  return contact.parent && 
    contact.reports.some(report => (report.form === 'case_investigation' && report.contact.parent && report.contact.parent._id === 'a7eb19a2-5d1d-4205-9e85-931ba0a32ffe') && report.fields.testing && report.fields.testing.cov_test ==='Positive');
};

const posCovidTestedMsa = (contact) => {
  return contact.parent && 
    contact.reports.some(report => (report.form === 'case_investigation' && report.contact.parent && report.contact.parent._id === '83bd1210-1a73-47d2-9f91-7c4f47bc9061') && report.fields.testing && report.fields.testing.cov_test ==='Positive');
};

module.exports = {
  allCovidTested,
  posCovidTested,
  negCovidTested,
  pendCovidTested,
  incCovidTested,
  emptCovidTested,
  mksCovidTested,
  kjdCovidTested,
  nrbCovidTested,
  msaCovidTested,
  posCovidTestedMks,
  posCovidTestedKjd,
  posCovidTestedNrb,
  posCovidTestedMsa
}; 

