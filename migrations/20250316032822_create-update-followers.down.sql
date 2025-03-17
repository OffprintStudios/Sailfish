-- Add down migration script here
DROP TRIGGER IF EXISTS profile_update_followers_trigger ON readers;
DROP FUNCTION IF EXISTS update_followers_count();