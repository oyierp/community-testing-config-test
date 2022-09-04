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
