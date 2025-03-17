-- Add up migration script here
CREATE OR REPLACE FUNCTION update_following_count()
RETURNS TRIGGER AS $$
        BEGIN
            UPDATE profiles
            SET following = (SELECT count(*) FROM followers WHERE profile_id = NEW.profile_id)
            WHERE id = NEW.profile_id;

            IF TG_OP = 'DELETE' THEN
                UPDATE profiles
                SET following = (SELECT count(*) FROM followers WHERE profile_id = OLD.profile_id)
                WHERE id = OLD.profile_id;

                RETURN OLD;
            ELSE
                RETURN NEW;
            END IF;
        END;
    $$ LANGUAGE plpgsql;

CREATE TRIGGER profile_update_following_trigger
    AFTER INSERT OR UPDATE OR DELETE ON followers
    FOR EACH ROW
    EXECUTE FUNCTION update_following_count();