DEFINE TABLE accounts TYPE ANY SCHEMAFULL
	PERMISSIONS
		FOR select, update, delete
			WHERE id = $auth.id
		FOR create NONE
;
DEFINE FIELD email ON accounts TYPE string ASSERT string::is::email($value)
	PERMISSIONS
		FOR select, create, update
			WHERE id = $auth.id
		FOR delete NONE
;
DEFINE FIELD password ON accounts TYPE string
	PERMISSIONS
		FOR select, delete NONE
		FOR create, update
			WHERE id = $auth.id
;
DEFINE FIELD terms_agree ON accounts TYPE bool DEFAULT false
	PERMISSIONS
		FOR select, update
			WHERE id = $auth.id
		FOR create, delete NONE
;
DEFINE FIELD email_confirmed ON accounts TYPE bool DEFAULT false
	PERMISSIONS
		FOR select, update
			WHERE id = $auth.id
		FOR create, delete NONE
;
DEFINE FIELD created_at ON accounts TYPE datetime DEFAULT time::now() READONLY
	PERMISSIONS FULL
;
DEFINE FIELD updated_at ON accounts TYPE datetime DEFAULT time::now() READONLY
	PERMISSIONS FULL
;
