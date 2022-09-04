SELECT 
	doc->>'_id' AS task_id, 
	to_timestamp((doc->>'created')::bigint/1000) as created, 
	EXTRACT('day' FROM now() - to_timestamp((doc->>'created')::bigint/1000)) AS days_since_created, 
	doc->'queue' AS queue 
FROM 
	couchdb 
WHERE 
	doc->>'type' = 'task:outbound';