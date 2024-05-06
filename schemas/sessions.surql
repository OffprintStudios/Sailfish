DEFINE TABLE sessions TYPE NORMAL SCHEMAFULL;

DEFINE FIELD account ON sessions TYPE record<account>;
DEFINE FIELD ip_addr ON sessions TYPE option<string> DEFAULT NONE;
DEFINE FIELD browser ON sessions TYPE option<string> DEFAULT NONE;
DEFINE FIELD device ON sessions TYPE option<string> DEFAULT NONE;
DEFINE FIELD os ON sessions TYPE option<string> DEFAULT NONE;
DEFINE FIELD created_at ON sessions TYPE datetime DEFAULT time::now() READONLY;
DEFINE FIELD expires_on ON sessions TYPE datetime DEFAULT time::now() + 4w2d READONLY;