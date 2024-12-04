-- Add up migration script here
CREATE TABLE IF NOT EXISTS accounts (
    id VARCHAR(21) PRIMARY KEY DEFAULT nanoid(),
    email TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL,
    roles TEXT[] NOT NULL DEFAULT '{"User"}',
    terms_agree BOOLEAN NOT NULL DEFAULT false,
    email_confirmed BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMPTZ NOT NULL DEFAULT current_timestamp,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT current_timestamp
);

SELECT manage_updated_at('accounts');