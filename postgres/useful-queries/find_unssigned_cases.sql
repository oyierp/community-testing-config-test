SELECT
 places.doc->>'name' AS place,
 cases.doc->>'name' AS case_name,
 cases.doc->>'subcounty' AS subcounty
FROM
	couchdb AS cases
	INNER JOIN couchdb AS places ON places.doc->>'_id' = cases.doc #>>'{parent,_id}'
WHERE
	cases.doc->>'contact_type' = 'forwarded_case'