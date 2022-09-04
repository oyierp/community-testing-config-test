
SELECT
	STAFF.day,
	STAFF.county,
	SUM(COALESCE(SUSPECTED_CASES.suspected_cases,0)) AS suspected_cases,
	SUM(COALESCE(CONFIRMED_CASES.confirmed_cases,0)) AS confirmed_cases,
	SUM(COALESCE(CASE_INVESTIGATIONS.case_investigations,0)) AS case_investigations,
	SUM(COALESCE(CONTACT_REGISTRATIONS.contacts_registered,0)) AS contacts_registered,
	SUM(COALESCE(CONTACT_FOLLOW_UPS.contacts_followed_up,0)) AS contacts_followed_up
FROM (
	SELECT 
	d::date as day,
	county.doc->>'name' AS county,
	staff.doc->>'name' as name,
	staff.doc #>>'{parent,_id}' AS staff_area,
	CASE WHEN staff.doc->>'contact_type' = 'rapid_response_team_member' THEN 'RRT' ELSE 'CT' END AS role
		
	FROM couchdb AS staff
	INNER JOIN couchdb AS county ON staff.doc #>>'{parent,parent,_id}' = county.doc->>'_id',
	generate_series( '2020-06-22'::date,  '2020-06-30'::date, interval '1 day')  as t(d)
	
	WHERE staff.doc->>'contact_type' IN('rapid_response_team_member','response_squad_member')
) AS STAFF
LEFT JOIN (
	SELECT
	doc#>>'{parent,_id}' AS staff_area,
	to_timestamp((doc->>'reported_date')::bigint / 1000)::date as day,
	COUNT(doc->>'_id') AS suspected_cases,
	SUM((doc->>'_rev' LIKE '1-%')::int) AS possible_transitions
	
	FROM
		couchdb AS suspected_cases
	WHERE doc->>'contact_type' = 'suspected_case'
	GROUP BY
		1,2
) AS SUSPECTED_CASES ON STAFF.staff_area = SUSPECTED_CASES.staff_area AND STAFF.day = SUSPECTED_CASES.day
LEFT JOIN (
	SELECT
	doc#>>'{parent,_id}' AS staff_area,
	to_timestamp((doc->>'reported_date')::bigint / 1000)::date as day,
	COUNT(doc->>'_id') AS confirmed_cases
	
	FROM
		couchdb
	WHERE doc->>'contact_type' = 'trace_case'
	GROUP BY
		1,2
) AS CONFIRMED_CASES ON STAFF.staff_area = CONFIRMED_CASES.staff_area AND STAFF.day = CONFIRMED_CASES.day
LEFT JOIN (

	SELECT
		doc#>>'{contact,parent,_id}' AS staff_area,
		to_timestamp((doc->>'reported_date')::bigint / 1000)::date as day,
		COUNT(*) AS case_investigations
		
		FROM
			couchdb
		WHERE doc->>'form' = 'case_investigation'
		GROUP BY
	1,2
	
) AS CASE_INVESTIGATIONS ON STAFF.staff_area = CASE_INVESTIGATIONS.staff_area AND STAFF.day = CASE_INVESTIGATIONS.day
LEFT JOIN (
	SELECT
	doc#>>'{parent,parent,_id}' AS staff_area,
	to_timestamp((doc->>'reported_date')::bigint / 1000)::date as day,
	COUNT(doc->>'_id') AS contacts_registered
	FROM
		couchdb
	WHERE 
		doc->>'contact_type' = 'trace_contact'
	GROUP BY
		1,2
) AS CONTACT_REGISTRATIONS ON STAFF.staff_area = CONTACT_REGISTRATIONS.staff_area AND STAFF.day = CONTACT_REGISTRATIONS.day

LEFT JOIN (
	SELECT
	doc#>>'{contact,parent,_id}' AS staff_area,
	to_timestamp((doc->>'reported_date')::bigint / 1000)::date as day,
	COUNT(DISTINCT doc#>>'{fields,patient_id}') AS contacts_followed_up
	FROM
		couchdb
	WHERE 
		doc->>'form' = 'contact_follow_up'
	GROUP BY
		1,2
) AS CONTACT_FOLLOW_UPS ON STAFF.staff_area = CONTACT_FOLLOW_UPS.staff_area AND STAFF.day = CONTACT_FOLLOW_UPS.day

GROUP BY 1,2
ORDER BY 1,2
