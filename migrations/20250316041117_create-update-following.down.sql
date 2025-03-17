-- Add down migration script here
DROP TRIGGER IF EXISTS profile_update_following_trigger ON readers;
DROP FUNCTION IF EXISTS update_following_count();