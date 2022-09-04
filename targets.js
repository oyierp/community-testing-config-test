const extras = require('./nools-extras');

const {
  allCovidTested,
  posCovidTested,
  negCovidTested,
  pendCovidTested,
  incCovidTested,
  emptCovidTested,
  mksCovidTested,
  nrbCovidTested,
  msaCovidTested,
  kjdCovidTested,
  posCovidTestedMks,
  posCovidTestedKjd,
  posCovidTestedNrb,
  posCovidTestedMsa
} = extras; 

module.exports = [  
  {
    id: 'screened-all-time',
    type: 'count',
    icon: 'medic-covid-case',
    goal: -1,
    translation_key: 'targets.all_timeScreened.title',
    subtitle_translation_key: 'targets.all_time.subtitle',
    appliesTo: 'contacts',
    appliesToType:['suspected_case'],
    date:'now',
    idType: 'contact'
  },

  {
    id: 'covid-test-all-time',
    type: 'count',
    icon: 'medic-covid-case',
    goal: 5120,
    translation_key: 'targets.all_timeCovid.title',
    subtitle_translation_key: 'targets.all_time.subtitle',
    appliesTo: 'contacts',
    appliesToType:['suspected_case'],
    appliesIf: function(contact){
      return allCovidTested (contact) - pendCovidTested(contact);
    },
    date:'now',
    idType: 'contact'
  },

  {
    id: 'posCovid-all-time',
    type: 'count',
    icon: 'medic-covid-case',
    goal: -1,
    translation_key: 'targets.posCovid.title',
    subtitle_translation_key: 'targets.all_time.subtitle',
    appliesTo: 'contacts',
    appliesToType:['suspected_case'],
    appliesIf:posCovidTested, 
    date: 'now',
  },

  {
    id: 'negCovid-all-time',
    type: 'count',
    icon: 'medic-covid-case',
    goal: -1,
    translation_key: 'targets.negCovid.title',
    subtitle_translation_key: 'targets.all_time.subtitle',
    appliesTo: 'contacts',
    appliesToType:['suspected_case'],
    appliesIf: negCovidTested,
    date:'now',
  },
  
  {
    id: 'pendCovid-test-all-time',
    type: 'count',
    icon: 'medic-covid-case',
    goal: -1,
    translation_key: 'targets.pendCovid.title',
    subtitle_translation_key: 'targets.all_time.subtitle',
    appliesTo: 'contacts',
    appliesToType:['suspected_case'],
    appliesIf: pendCovidTested,
    date:'now',
  },

  {
    id: 'incEmpCovid-test-all-time',
    type: 'count',
    icon: 'medic-covid-case',
    goal: -1,
    translation_key: 'targets.incEmpCovid.title',
    subtitle_translation_key: 'targets.all_time.subtitle',
    appliesTo: 'contacts',
    appliesToType:['suspected_case'],
    appliesIf: function(contact){
      return incCovidTested (contact) || emptCovidTested(contact);
    },
    date:'now',
  },
  
  {
    id: 'mksCovid-test-all-time',
    type: 'percent',
    icon: 'medic-covid-case',
    goal: 640,
    translation_key: 'targets.mksCovid.title',
    subtitle_translation_key: 'targets.all_time.subtitle',
    appliesTo: 'contacts',
    appliesToType:['suspected_case'],
    appliesIf: mksCovidTested,
    date:'now',
  },

  {
    id: 'kjdCovid-test-all-time',
    type: 'percent',
    icon: 'medic-covid-case',
    goal: 640,
    translation_key: 'targets.kjdCovid.title',
    subtitle_translation_key: 'targets.all_time.subtitle',
    appliesTo: 'contacts',
    appliesToType:['suspected_case'],
    appliesIf: kjdCovidTested,
    date:'now',
  },

  {
    id: 'nrbCovid-test-all-time',
    type: 'percent',
    icon: 'medic-covid-case',
    goal: 2720,
    translation_key: 'targets.nrbCovid.title',
    subtitle_translation_key: 'targets.all_time.subtitle',
    appliesTo: 'contacts',
    appliesToType:['suspected_case'],
    appliesIf: nrbCovidTested,
    date:'now',
  },

  {
    id: 'msaCovid-test-all-time',
    type: 'percent',
    icon: 'medic-covid-case',
    goal: 1120,
    translation_key: 'targets.msaCovid.title',
    subtitle_translation_key: 'targets.all_time.subtitle',
    appliesTo: 'contacts',
    appliesToType:['suspected_case'],
    appliesIf: msaCovidTested,
    date:'now',
  },
  
  {
    id: 'posCovidTestedMks-test-all-time',
    type: 'count',
    icon: 'medic-covid-case',
    goal: -1,
    translation_key: 'targets.posCovidMks.title',
    subtitle_translation_key: 'targets.all_time.subtitle',
    appliesTo: 'contacts',
    appliesToType:['suspected_case'],
    appliesIf: posCovidTestedMks,
    date:'now',
  },

  {
    id: 'posCovidKjd-test-all-time',
    type: 'count',
    icon: 'medic-covid-case',
    goal: -1,
    translation_key: 'targets.posCovidKjd.title',
    subtitle_translation_key: 'targets.all_time.subtitle',
    appliesTo: 'contacts',
    appliesToType:['suspected_case'],
    appliesIf: posCovidTestedKjd,
    date:'now',
  },

  { 
    id: 'posCovidNrb-test-all-time',
    type: 'count',
    icon: 'medic-covid-case',
    goal: -1,
    translation_key: 'targets.posCovidNrb.title',
    subtitle_translation_key: 'targets.all_time.subtitle',
    appliesTo: 'contacts',
    appliesToType:['suspected_case'],
    appliesIf: posCovidTestedNrb,
    date:'now',
  },

  { 
    id: 'posCovidMsa-test-all-time',
    type: 'count',
    icon: 'medic-covid-case',
    goal: -1,
    translation_key: 'targets.posCovidMsa.title',
    subtitle_translation_key: 'targets.all_time.subtitle',
    appliesTo: 'contacts',
    appliesToType:['suspected_case'],
    appliesIf: posCovidTestedMsa, 
    date:'now',
  },

];
