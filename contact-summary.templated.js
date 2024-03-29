const fields = [
  { appliesToType: 'person', label: 'contact.age', value: contact.date_of_birth, width: 4, filter: 'age' },
  { appliesToType: 'person', label: 'contact.sex', value: 'contact.sex.' + contact.gender, translate: true, width: 4 },
  { appliesToType: 'person', label: 'contact.phone', value: contact.phone_number, width: 4, filter: 'phone' },
  { appliesToType: 'person', label: 'contact.parent', value: lineage, filter: 'lineage' },
  { appliesToType: 'person', label: 'ID Number', value: contact.id_number || contact.passport_number || contact.alien_number || 'N/A', width: 4 },

];

const now = new Date();
const getElaspsedMilliseconds = (now) => {
  const startOfDay = new Date();
  startOfDay.setHours(0);
  startOfDay.setMinutes(0);
  startOfDay.setSeconds(0);
  startOfDay.setMilliseconds(0);

  return parseInt((now - startOfDay) / 1000);
};

const getDayOfYear = now => {
  const startOfYear = new Date(now.getFullYear(), 0, 0);
  const diff = (now - startOfYear) + ((startOfYear.getTimezoneOffset() - now.getTimezoneOffset()) * 60 * 1000);
  const oneDay = 1000 * 60 * 60 * 24;
  return Math.floor(diff / oneDay);
};

const context = {};
context.has_case_investigation = reports.some((report) => report.form === 'case_investigation' && report.fields.stop_follow_up === 'yes');
context.monotonic_counter = `${getDayOfYear(now)}-${getElaspsedMilliseconds(now)}`;

module.exports = {
  fields,
  cards: [],
  context
};
