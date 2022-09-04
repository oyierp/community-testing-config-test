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
    contact.reports.some(report => (report.form === 'case_investigation' && report.contact.parent && report.contact.parent._id === 'a2df09b4-6942-48a4-bda4-e730bd3e9e6e') && report.fields.testing && report.fields.testing.cov_test);
};

const kjdCovidTested = (contact) => {
  return contact.parent && 
    contact.reports.some(report => (report.form === 'case_investigation' && report.contact.parent && report.contact.parent._id === '792ab916-1422-499c-82df-abf19afd33e5') && report.fields.testing && report.fields.testing.cov_test);
};

const nrbCovidTested = (contact) => {
  return contact.parent && 
    contact.reports.some(report => (report.form === 'case_investigation' && report.contact.parent && report.contact.parent._id === '8d4c38d1-d946-4652-ad19-c59639512958') && report.fields.testing && report.fields.testing.cov_test);
};

const msaCovidTested = (contact) => {
  return contact.parent && 
    contact.reports.some(report => (report.form === 'case_investigation' && report.contact.parent && report.contact.parent._id === 'f32fcac5-9395-4e64-8da9-2b86d4474e0f') && report.fields.testing && report.fields.testing.cov_test);
};

const posCovidTestedMks = (contact) => {
  return contact.parent && 
    contact.reports.some(report => (report.form === 'case_investigation' && report.contact.parent && report.contact.parent._id === 'a2df09b4-6942-48a4-bda4-e730bd3e9e6e') && report.fields.testing && report.fields.testing.cov_test ==='Positive');
};

const posCovidTestedKjd = (contact) => {
  return contact.parent && 
    contact.reports.some(report => (report.form === 'case_investigation' && report.contact.parent && report.contact.parent._id === '792ab916-1422-499c-82df-abf19afd33e5') && report.fields.testing && report.fields.testing.cov_test ==='Positive');
};

const posCovidTestedNrb = (contact) => {
  return contact.parent && 
    contact.reports.some(report => (report.form === 'case_investigation' && report.contact.parent && report.contact.parent._id === '8d4c38d1-d946-4652-ad19-c59639512958') && report.fields.testing && report.fields.testing.cov_test ==='Positive');
};

const posCovidTestedMsa = (contact) => {
  return contact.parent && 
    contact.reports.some(report => (report.form === 'case_investigation' && report.contact.parent && report.contact.parent._id === 'f32fcac5-9395-4e64-8da9-2b86d4474e0f') && report.fields.testing && report.fields.testing.cov_test ==='Positive');
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

