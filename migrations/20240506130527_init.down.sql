-- Add down migration script here
DROP EXTENSION IF EXISTS "uuid-ossp";

DROP FUNCTION IF EXISTS manage_updated_at(_tbl regclass);
DROP FUNCTION IF EXISTS set_updated_at()