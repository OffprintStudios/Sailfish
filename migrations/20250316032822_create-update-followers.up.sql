-- Add up migration script here
CREATE OR REPLACE FUNCTION update_followers_count()
RETURNS TRIGGER AS $$
        BEGIN
            UPDATE profiles
            SET followers = (SELECT count(*) FROM followers WHERE subscribed_to = NEW.subscribed_to)
            WHERE id = NEW.subscribed_id;

            IF TG_OP = 'DELETE' THEN
                UPDATE profiles
                SET followers = (SELECT count(*) FROM followers WHERE subscribed_to = OLD.subscribed_to)
                WHERE id = OLD.subscribed_id;

                RETURN OLD;
            ELSE
                RETURN NEW;
            END IF;
        END;
    $$ LANGUAGE plpgsql;

CREATE TRIGGER profile_update_followers_trigger
    AFTER INSERT OR UPDATE OR DELETE ON followers
    FOR EACH ROW
    EXECUTE FUNCTION update_followers_count();
