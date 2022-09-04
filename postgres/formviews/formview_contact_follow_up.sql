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

