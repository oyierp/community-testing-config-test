module.exports = {
  contact_follow_up: {
    actions: {
      in_person_asymptomatic: {
        data: [['in_person', 'available', 'asymptomatic']]
      },
      in_person_symptomatic: {
        data: [['in_person', 'available', 'symptomatic', '', 'yes', 'yes', 'yes', 'yes', 'yes']],
        expectation: {
          property: 'group_follow_up',
          value: {
            needs_referral: 'true'
          }
        }
      },
      in_person_deceased_future: {
        data: [['in_person', 'available', 'deceased', '9999-01-01']],
        fail: true
      },
      in_person_deceased_past: {
        data: [['in_person', 'available', 'deceased', '1000-01-01']],
      }
    }
  },
  case_investigation: {
    actions: {
      detected_at_poe: {
        data: [
          ['1000-01-01', 'Some facility', 'Nairobi', 'Kibra', 'point_of_entry', '1000-01-01'],
          ['yes', '1000-01-01', 'yes', '1000-01-01', 'Some hospital', '1000-01-01', 'no', 'stable'],
          ['cough,sore_throat'],
          ['37', 'others', 'some danger signs'],
          ['pregnancy', 'first'],
          ['student', 'yes', 'international_travel', '2', 'Syria', '1000-01-01', 'Uganda', '1000-01-01', 'no', 'no', 'no', 'no'],
          ['yes', '1000-01-01', 'np_swab', 'Lancet', '1000-01-01']
        ]
      }
    }
  },
  contacts: {
    actions: {
      suspected_case: {
        data: [['national_id', '121212121', 'surname', 'firstname', 'othername', 'female', 'yes', '1970-01-01', 'single', 'student', '', 'no', 'Kenya', '+254711000000', '+254711000001', ...Array(2).fill(''), 'Nairobi', 'Kibra', ...Array(11).fill('')]]
      }
    }
  }
};
