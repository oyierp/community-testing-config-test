SELECT
	doc->>'kemr_uuid' AS kemr_uuid,
	doc->>'name' AS case_name,
	COUNT(*) AS duplicates
FROM
	couchdb
WHERE
	doc->>'contact_type' = 'trace_case'
GROUP BY 1,2
HAVING COUNT(*) > 1;