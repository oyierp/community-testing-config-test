SELECT
	place.doc->>'name' as place,
	to_timestamp((cases.doc->>'reported_date')::bigint / 1000)::date as day_forwarded,
	COUNT(cases.doc->>'_id') AS count
	FROM
		couchdb as cases
		INNER JOIN couchdb place ON place.doc->>'_id' = cases.doc#>>'{parent,_id}'
	WHERE 
		cases.doc->>'contact_type' = 'forwarded_case'
	GROUP BY
		1,2