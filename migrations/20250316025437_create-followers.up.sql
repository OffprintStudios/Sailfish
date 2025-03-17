-- Add up migration script here
CREATE TABLE IF NOT EXISTS followers (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    profile_id VARCHAR(21) NOT NULL REFERENCES profiles (id) ON DELETE CASCADE,
    subscribed_to VARCHAR(21) NOT NULL REFERENCES profiles (id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT current_timestamp,
    UNIQUE (profile_id, subscribed_to)
);