-- Add down migration script here
DROP FUNCTION IF EXISTS nanoid(int, text, float);
DROP FUNCTION IF EXISTS nanoid_optimized(int, text, int, int);