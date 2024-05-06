DEFINE TABLE accounts TYPE NORMAL SCHEMAFULL;

DEFINE FIELD email ON accounts TYPE string ASSERT string::is::email($value);
DEFINE FIELD password ON accounts TYPE string;
DEFINE FIELD terms_agree ON accounts TYPE bool DEFAULT false;
DEFINE FIELD email_confirmed ON accounts TYPE bool DEFAULT false;
DEFINE FIELD created_at ON accounts TYPE datetime DEFAULT time::now() READONLY;
DEFINE FIELD updated_at ON accounts TYPE datetime DEFAULT time::now() READONLY;

DEFINE INDEX account_email_idx ON TABLE accounts COLUMNS email UNIQUE;