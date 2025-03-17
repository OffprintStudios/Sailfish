-- Add up migration script here
CREATE TABLE IF NOT EXISTS profiles (
    id VARCHAR(21) PRIMARY KEY DEFAULT nanoid(),
    account_id UUID NOT NULL REFERENCES accounts (id) ON DELETE CASCADE,
    username TEXT UNIQUE NOT NULL,
    avatar TEXT NOT NULL DEFAULT 'https://images.offprint.net/avatars/avatar.png',
    banner_art TEXT DEFAULT NULL,
    bio TEXT NOT NULL DEFAULT 'Just another friendly face in the crowd',
    tagline TEXT DEFAULT NULL,
    links TEXT[] NOT NULL DEFAULT '{}',
    works INTEGER NOT NULL DEFAULT 0,
    blogs INTEGER NOT NULL DEFAULT 0,
    followers BIGINT NOT NULL DEFAULT 0,
    following BIGINT NOT NULL DEFAULT 0,
    "default" BOOLEAN NOT NULL DEFAULT false,
    roles TEXT[] NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT current_timestamp,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT current_timestamp,
    deleted_at TIMESTAMPTZ DEFAULT NULL
);

SELECT manage_updated_at('profiles');