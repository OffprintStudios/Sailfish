-- Add up migration script here
CREATE TABLE IF NOT EXISTS password_resets (
    id VARCHAR(21) PRIMARY KEY DEFAULT nanoid(),
    account_id VARCHAR(21) NOT NULL REFERENCES accounts (id) ON DELETE CASCADE,
    token VARCHAR(21) NOT NULL DEFAULT nanoid(),
    used BOOLEAN NOT NULL DEFAULT false,
    expires_on TIMESTAMPTZ NOT NULL DEFAULT (current_timestamp + interval '1' hour),
    created_at TIMESTAMPTZ NOT NULL DEFAULT current_timestamp
);