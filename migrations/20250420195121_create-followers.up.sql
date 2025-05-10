-- Add up migration script here
CREATE TABLE IF NOT EXISTS followers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    profile_id CHAR(21) NOT NULL REFERENCES profiles (id) ON DELETE CASCADE,
    subscribed_to CHAR(21) NOT NULL REFERENCES profiles (id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT current_timestamp,
    UNIQUE (profile_id, subscribed_to)
);
