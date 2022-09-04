SELECT
	doc->>'kemr_uuid' AS kemr_uuid,
	doc->>'case_name' AS case_name,
	COUNT(*) AS duplicates
FROM
	couchdb
WHERE
	doc->>'contact_type' = 'forwarded_case'
GROUP BY 1,2
HAVING COUNT(*) > 1;