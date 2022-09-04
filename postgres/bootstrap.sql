 -- GENERATED 2020-08-25T17:38:41.N


CREATE OR REPLACE FUNCTION f_cast_isots(text)
  RETURNS timestamp AS
$$SELECT to_timestamp($1::bigint/1000)::timestamp without time zone $$  -- adapt to your needs
  LANGUAGE sql IMMUTABLE;

DROP VIEW IF EXISTS formview_case_investigation;
CREATE VIEW formview_case_investigation AS
SELECT
  doc #>> '{fields,inputs,source}' AS source,
  doc #>> '{fields,inputs,source_id}' AS source_id,
  doc #>> '{fields,patient_id}' AS patient_id,
  doc #>> '{fields,patient_age_in_years}' AS patient_age_in_years,
  doc #>> '{fields,patient_age_in_months}' AS patient_age_in_months,
  doc #>> '{fields,group_reporting_info,date_of_reporting}' AS date_of_reporting,
  doc #>> '{fields,group_reporting_info,reporting_facility}' AS reporting_facility,
  doc #>> '{fields,group_reporting_info,reporting_facility}' AS county,
  doc #>> '{fields,group_reporting_info,subcounty}' AS subcounty,
  doc #>> '{fields,group_reporting_info,poe_detected}' AS poe_detected,
  doc #>> '{fields,group_reporting_info,poe_detection_date}' AS poe_detection_date,
  doc #>> '{fields,group_clinical_information,patient_condition}' AS patient_condition,
  doc #>> '{fields,group_clinical_information,symptoms_onset_date}' AS symptoms_onset_date,
  doc #>> '{fields,group_clinical_information,unknown_hospital_condition}' AS unknown_hospital_condition,
  doc #>> '{fields,group_clinical_information,first_admission_date}' AS first_admission_date,
  doc #>> '{fields,group_clinical_information,hospital_name}' AS hospital_name,
  doc #>> '{fields,group_clinical_information,isolation_date}' AS isolation_date,
  doc #>> '{fields,group_clinical_information,patient_ventilated}' AS patient_ventilated,
  doc #>> '{fields,group_clinical_information,patient_health_status}' AS patient_health_status,
  doc #>> '{fields,group_clinical_information,death_date}' AS death_date,
  doc #>> '{fields,group_patient_symptoms,death_date}' AS patient_symptoms,
  doc #>> '{fields,group_patient_symptoms,symptoms_specify}' AS symptoms_specify,
  doc #>> '{fields,group_patient_symptoms,pain_type}' AS pain_type,
  doc #>> '{fields,group_patient_signs,temperature}' AS temperature,
  doc #>> '{fields,group_patient_signs,reported_patient_signs}' AS reported_patient_signs,
  doc #>> '{fields,group_patient_signs,reported_patient_signs_specify}' AS reported_patient_signs_specify,
  doc #>> '{fields,group_conditions_comorbidity,conditions_comorbidity}' AS conditions_comorbidity,
  doc #>> '{fields,group_conditions_comorbidity,trimester}' AS trimester,
  doc #>> '{fields,group_conditions_comorbidity,conditions_comorbidity_others}' AS conditions_comorbidity_others,
  doc #>> '{fields,group_exposure_travel_information,occupation}' AS occupation,
  doc #>> '{fields,group_exposure_travel_information,specify_occupation}' AS specify_occupation,
  doc #>> '{fields,group_exposure_travel_information,patient_travelled_past_2_weeks}' AS patient_travelled_past_2_weeks,
  doc #>> '{fields,group_exposure_travel_information,travel_type}' AS travel_type,
  doc #>> '{fields,group_exposure_travel_information,no_of_countries}' AS no_of_countries,
  doc #>> '{fields,group_exposure_travel_information,group_cities}' AS cities,
  doc #>> '{fields,group_exposure_travel_information,place_from}' AS place_from,
  doc #>> '{fields,group_exposure_travel_information,place_from}' AS place_to,
  doc #>> '{fields,group_exposure_travel_information,has_patient_visited_facility_2_weeks}' AS has_patient_visited_facility_2_weeks,
  doc #>> '{fields,group_exposure_travel_information,patient_had_close_contact_ari}' AS patient_had_close_contact_ari,
  doc #>> '{fields,group_exposure_travel_information,contact_setting}' AS contact_setting,
  doc #>> '{fields,group_exposure_travel_information,specify_contact_settings}' AS specify_contact_settings,
  doc #>> '{fields,group_exposure_travel_information,patient_had_close_contact_with_case}' AS patient_had_close_contact_with_case,
  doc #>> '{fields,group_exposure_travel_information,visited_live_animal_market}' AS visited_live_animal_market,
  doc #>> '{fields,group_exposure_travel_information,animal_market_location}' AS animal_market_location,
  doc #>> '{fields,group_laboratory_information,was_specimen_collected}' AS was_specimen_collected,
  doc #>> '{fields,group_laboratory_information,why_specimen_collected}' AS why_specimen_was_not_collected,
  doc #>> '{fields,group_laboratory_information,specimen_id}' AS specimen_id,
  doc #>> '{fields,group_laboratory_information,date_specimen_collected}' AS date_specimen_collected,
  doc #>> '{fields,group_laboratory_information,specimen_type}' AS specimen_type,
  doc #>> '{fields,group_laboratory_information,specify_specimen}' AS specify_specimen,
  doc #>> '{fields,group_laboratory_information,testing_lab}' AS testing_lab,
  doc #>> '{fields,group_laboratory_information,date_specimen_sent}' AS date_specimen_sent
FROM
  couchdb
WHERE
  doc ->> 'type' = 'data_record' AND 
  doc ->> 'form' = 'case_investigation'
;



DROP VIEW IF EXISTS formview_contact_follow_up;
CREATE VIEW formview_contact_follow_up AS
SELECT
  doc #>> '{fields,inputs,source}' AS source,
  doc #>> '{fields,inputs,source_id}' AS source_id,
  doc #>> '{fields,patient_id}' AS patient_id,
  doc #>> '{fields,patient_uuid}' AS patient_uuid,
  doc #>> '{fields,patient_age_in_years}' AS patient_age_in_years,
  doc #>> '{fields,patient_age_in_months}' AS patient_age_in_months,
  doc #>> '{fields,has_symptoms}' AS has_symptoms,
  doc #>> '{fields,group_follow_up,follow_up_type}' AS follow_up_type,
  doc #>> '{fields,group_follow_up,status_call}' AS status_call,
  doc #>> '{fields,group_follow_up,status_call_other}' AS status_call_other,
  doc #>> '{fields,group_follow_up,status_visit}' AS status_visit,
  doc #>> '{fields,group_follow_up,status_visit_other}' AS status_visit_other,
  doc #>> '{fields,group_follow_up,is_available}' AS is_available,
  doc #>> '{fields,group_follow_up,symptoms}' AS symptoms,
  doc #>> '{fields,group_follow_up,date_of_death}' AS date_of_death,
  doc #>> '{fields,group_follow_up,temperature}' AS temperature,
  doc #>> '{fields,group_follow_up,c_fever}' AS fever,
  doc #>> '{fields,group_follow_up,cough}' AS cough,
  doc #>> '{fields,group_follow_up,running_nose}' AS running_nose,
  doc #>> '{fields,group_follow_up,sore_throat}' AS sore_throat,
  doc #>> '{fields,group_follow_up,difficulty_breathing}' AS difficulty_breathing,
  doc #>> '{fields,group_follow_up,other_symptoms}' AS other_symptoms,
  doc #>> '{fields,group_follow_up,needs_referral}' AS needs_referral
FROM
  couchdb
WHERE
  doc ->> 'type' = 'data_record' AND 
  doc ->> 'form' = 'contact_follow_up'
;



DROP FUNCTION IF EXISTS get_dashboard_data(from_date timestamp without time zone, to_date timestamp without time zone, aggregated boolean);

CREATE FUNCTION get_dashboard_data(from_date timestamp without time zone, to_date timestamp without time zone, aggregated boolean)
RETURNS TABLE(
  day date,
  county text,
  suspected_cases int,
  confirmed_cases int,
  unassigned_cases int,
  active_users int,
  contacts_registered int,
  contacts_followed_up int,
  case_investigations int
) AS
$BODY$

SELECT
  STAFF.day,
  STAFF.county,
  SUM(COALESCE(SUSPECTED_CASES.suspected_cases,0))::int AS suspected_cases,
  SUM(COALESCE(CONFIRMED_CASES.confirmed_cases,0))::int AS confirmed_cases,
  SUM(COALESCE(FORWARDED_CASES.count,0))::int AS unassigned_cases,
  SUM(COALESCE(ACTIVE_STAFF.active,0))::int AS  active_users,
  SUM(COALESCE(CONTACT_REGISTRATIONS.contacts_registered,0))::int AS contacts_registered,
  SUM(COALESCE(CONTACT_FOLLOW_UPS.contacts_followed_up,0))::int AS contacts_followed_up,
  SUM(COALESCE(CASE_INVESTIGATIONS.case_investigations,0))::int AS case_investigations
FROM (
    SELECT 
      d::date as day,
      doc->>'_id' AS county_id,
      doc->>'name' AS county

    FROM 
      couchdb,
      generate_series( CASE WHEN aggregated IS FALSE THEN from_date::date ELSE to_date::date END,  to_date::date, interval '1 day')  AS t(d)
    WHERE
      doc->>'type' = 'contact' AND 
      doc->>'contact_type' = 'county_office'
) AS STAFF
LEFT JOIN (
  SELECT
    doc#>>'{parent,parent,_id}' AS county_id,
    CASE 
      WHEN aggregated IS FALSE 
      THEN to_timestamp((doc->>'reported_date')::bigint / 1000)::date
      ELSE to_date::date
    END AS day,
    COUNT(doc->>'_id') AS suspected_cases,
    SUM((doc->>'_rev' LIKE '1-%')::int) AS possible_transitions
  FROM
    couchdb AS suspected_cases
  WHERE 
    doc->>'type' = 'contact' AND
    doc->>'contact_type' = 'suspected_case' AND 
    f_cast_isots(doc->>'reported_date') >= from_date AND 
    f_cast_isots(doc->>'reported_date') < to_date + '1 day'::interval
  GROUP BY
    county_id,
    day
) AS SUSPECTED_CASES ON STAFF.county_id = SUSPECTED_CASES.county_id AND SUSPECTED_CASES.day = STAFF.day
LEFT JOIN (
  SELECT
    doc#>>'{parent,parent,_id}' AS county_id,
    CASE 
      WHEN aggregated IS FALSE 
      THEN to_timestamp((doc->>'reported_date')::bigint / 1000)::date
      ELSE to_date::date
    END AS day,
    COUNT(doc->>'_id') AS confirmed_cases
  FROM
    couchdb
  WHERE 
    doc->>'type' = 'contact' AND
    doc->>'contact_type' = 'trace_case'AND 
    f_cast_isots(doc->>'reported_date') >= from_date AND 
    f_cast_isots(doc->>'reported_date') < to_date + '1 day'::interval
  GROUP BY
    county_id,
    day
) AS CONFIRMED_CASES ON STAFF.county_id = CONFIRMED_CASES.county_id AND CONFIRMED_CASES.day = STAFF.day

LEFT JOIN (
  SELECT
    doc#>>'{parent,_id}' AS county_id,
    CASE 
      WHEN aggregated IS FALSE 
      THEN to_timestamp((doc->>'reported_date')::bigint / 1000)::date
      ELSE to_date::date
    END AS day,
    COUNT(doc->>'_id') AS count
  FROM
    couchdb
  WHERE 
    doc->>'type' = 'contact' AND
    doc->>'contact_type' = 'forwarded_case' AND 
    f_cast_isots(doc->>'reported_date') >= from_date AND 
    f_cast_isots(doc->>'reported_date') < to_date + '1 day'::interval
  GROUP BY
    county_id,
    day
  ) AS FORWARDED_CASES ON STAFF.county_id = FORWARDED_CASES.county_id AND STAFF.day = FORWARDED_CASES.day

LEFT JOIN (

  SELECT
    county_id,
    day,
    COUNT(DISTINCT place_id) AS active
  FROM (
    SELECT
      doc#>>'{parent,parent,_id}' AS county_id,
      CASE 
        WHEN aggregated IS FALSE 
        THEN to_timestamp((doc->>'reported_date')::bigint / 1000)::date
        ELSE to_date::date
      END AS day,
      doc#>>'{parent,_id}' AS place_id
    FROM
      couchdb
    WHERE
      doc->>'type' = 'contact' AND  
      doc->>'contact_type' = 'suspected_case' AND 
      f_cast_isots(doc->>'reported_date') >= from_date AND 
      f_cast_isots(doc->>'reported_date') < to_date + '1 day'::interval
    GROUP BY
      county_id,
      day,
      place_id
      
    UNION ALL
    
    SELECT
      doc#>>'{parent,parent,parent,_id}' AS county_id,
      CASE 
        WHEN aggregated IS FALSE 
        THEN to_timestamp((doc->>'reported_date')::bigint / 1000)::date
        ELSE to_date::date
      END AS day,
      doc#>>'{parent,parent,_id}' AS place_id
    FROM
      couchdb
    WHERE 
      doc->>'type' = 'contact' AND
      doc->>'contact_type' = 'trace_contact' AND doc->>'trace' = '{}' AND 
      f_cast_isots(doc->>'reported_date') >= from_date AND 
      f_cast_isots(doc->>'reported_date') < to_date + '1 day'::interval
    GROUP BY
      county_id,
      day,
      place_id
      
    UNION ALL
    
    SELECT
      doc#>>'{contact,parent,parent,_id}' AS county_id,
      CASE 
        WHEN aggregated IS FALSE 
        THEN to_timestamp((doc->>'reported_date')::bigint / 1000)::date
        ELSE to_date::date
      END AS day,
      doc#>>'{contact,parent,_id}' AS place_id
    FROM
      couchdb
    WHERE 
      doc->>'type' = 'data_record' AND
      doc->>'form' IN ('contact_follow_up', 'case_investigation') AND 
      f_cast_isots(doc->>'reported_date') >= from_date AND 
      f_cast_isots(doc->>'reported_date') < to_date + '1 day'::interval
    GROUP BY
      county_id,
      day,
      place_id
  ) AS ACTIVITY
  
  GROUP BY 1,2
) AS ACTIVE_STAFF ON STAFF.county_id = ACTIVE_STAFF.county_id AND STAFF.day = ACTIVE_STAFF.day
LEFT JOIN (
  SELECT
    doc#>>'{parent,parent,parent,_id}' AS county_id,
    CASE 
      WHEN aggregated IS FALSE 
      THEN to_timestamp((doc->>'reported_date')::bigint / 1000)::date
      ELSE to_date::date
    END AS day,
    COUNT(doc->>'_id') AS contacts_registered
  FROM
    couchdb
  WHERE 
    doc->>'type' = 'contact' AND 
    doc->>'contact_type' = 'trace_contact' AND 
    f_cast_isots(doc->>'reported_date') >= from_date AND 
    f_cast_isots(doc->>'reported_date') < to_date + '1 day'::interval
  GROUP BY
    county_id,
    day
) AS CONTACT_REGISTRATIONS ON STAFF.county_id = CONTACT_REGISTRATIONS.county_id AND STAFF.day = CONTACT_REGISTRATIONS.day

LEFT JOIN (
  SELECT
    doc#>>'{contact,parent,parent,_id}' AS county_id,
    CASE 
      WHEN aggregated IS FALSE 
      THEN to_timestamp((doc->>'reported_date')::bigint / 1000)::date
      ELSE to_date::date
    END AS day,
    COUNT(DISTINCT doc#>>'{fields,patient_id}') AS contacts_followed_up
  FROM
    couchdb
  WHERE 
    doc->>'type' = 'data_record' AND
    doc->>'form' = 'contact_follow_up' AND 
    f_cast_isots(doc->>'reported_date') >= from_date AND 
    f_cast_isots(doc->>'reported_date') < to_date + '1 day'::interval
  GROUP BY
    county_id,
    day
) AS CONTACT_FOLLOW_UPS ON STAFF.county_id = CONTACT_FOLLOW_UPS.county_id AND STAFF.day = CONTACT_FOLLOW_UPS.day
LEFT JOIN (
  SELECT
    doc#>>'{contact,parent,parent,_id}' AS county_id,
    CASE 
      WHEN aggregated IS FALSE 
      THEN to_timestamp((doc->>'reported_date')::bigint / 1000)::date
      ELSE to_date::date
    END AS day,
    COUNT(DISTINCT doc#>>'{fields,patient_id}') AS case_investigations
  FROM
    couchdb
  WHERE 
    doc->>'type' = 'data_record' AND 
    doc->>'form' = 'case_investigation' AND 
    f_cast_isots(doc->>'reported_date') >= from_date AND 
    f_cast_isots(doc->>'reported_date') < to_date + '1 day'::interval
  GROUP BY
    county_id,
    day
) AS CASE_INVESTIGATIONS ON STAFF.county_id = CASE_INVESTIGATIONS.county_id AND STAFF.day = CASE_INVESTIGATIONS.day

GROUP BY 
    STAFF.county,
    STAFF.day
ORDER BY 
    STAFF.county,
    STAFF.day;
$BODY$
LANGUAGE 'sql' STABLE;

ALTER FUNCTION get_dashboard_data(timestamp without time zone, timestamp without time zone, boolean) OWNER TO "covid-ke";


DROP INDEX IF EXISTS couchdb_doc_form;
CREATE INDEX couchdb_doc_form ON couchdb ((doc->>'form')) WHERE doc->>'type' = 'data_record';

DROP INDEX IF EXISTS couchdb_doc_contact_type;
CREATE INDEX couchdb_doc_contact_type ON couchdb((doc->>'contact_type'), (doc->>'trace')) WHERE doc->>'type' = 'contact';

DROP INDEX IF EXISTS couchdb_doc_contact_type_name ;
CREATE INDEX couchdb_doc_contact_type_name ON couchdb((doc->>'contact_type'), (doc->>'name')) WHERE doc->>'type' = 'contact';

DROP INDEX IF EXISTS couchdb_doc_form_contact;
CREATE INDEX couchdb_doc_form_contact ON couchdb(((doc#>>'{contact,_id}')::text)) WHERE (doc ->> 'form' IS NOT NULL);

DROP INDEX IF EXISTS couchdb_doc_form_contact_parent;
CREATE INDEX couchdb_doc_form_contact_parent ON couchdb(((doc#>>'{contact,parent,_id}')::text)) WHERE (doc ->> 'form' IS NOT NULL);

DROP INDEX IF EXISTS couchdb_doc_form_contact_parent_parent;
CREATE INDEX couchdb_doc_form_contact_parent_parent ON couchdb(((doc#>>'{contact,parent,parent,_id}')::text)) WHERE (doc ->> 'form'  IS NOT NULL);

DROP INDEX IF EXISTS couchdb_doc_contact_parent;
CREATE INDEX couchdb_doc_contact_parent ON couchdb(((doc#>>'{parent,_id}')::text)) WHERE (doc ->> 'type' = 'contact');

DROP INDEX IF EXISTS couchdb_doc_contact_parent_parent;
CREATE INDEX couchdb_doc_contact_parent_parent ON couchdb(((doc#>>'{parent,parent,_id}')::text)) WHERE (doc ->> 'type' = 'contact');

DROP INDEX IF EXISTS couchdb_doc_contact_parent_parent_parent;
CREATE INDEX couchdb_doc_contact_parent_parent_parent ON couchdb(((doc#>>'{parent,parent,parent,_id}')::text)) WHERE (doc ->> 'type' = 'contact');

VACUUM ANALYZE;

