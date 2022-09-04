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