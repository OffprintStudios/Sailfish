-- Add down migration script here
DROP FUNCTION IF EXISTS manage_updated_at(_tbl regclass);
DROP FUNCTION IF EXISTS set_updated_at();