-- Add up migration script here
CREATE TABLE IF NOT EXISTS profiles (
    id VARCHAR(21) PRIMARY KEY NOT NULL,
    account_id UUID NOT NULL REFERENCES accounts (id),
    username TEXT UNIQUE NOT NULL,
    avatar TEXT NOT NULL DEFAULT 'https://images.offprint.net/avatars/avatar.png',
    banner_art TEXT DEFAULT NULL,
    bio TEXT NOT NULL DEFAULT 'Just another friendly face in the crowd',
    tagline TEXT DEFAULT NULL,
    links TEXT[] NOT NULL DEFAULT '{}',
    presence TEXT NOT NULL DEFAULT 'offline',
    created_at TIMESTAMPTZ NOT NULL DEFAULT current_timestamp,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT current_timestamp,
);

SELECT manage_updated_at('profiles');