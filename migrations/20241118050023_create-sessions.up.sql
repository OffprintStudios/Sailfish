-- Add up migration script here
CREATE TABLE IF NOT EXISTS sessions (
    id VARCHAR(21) PRIMARY KEY DEFAULT nanoid(),
    account_id VARCHAR(21) NOT NULL REFERENCES accounts (id) ON DELETE CASCADE,
    ip_addr TEXT DEFAULT NULL,
    browser TEXT DEFAULT NULL,
    device TEXT DEFAULT NULL,
    os TEXT DEFAULT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT current_timestamp,
    expires_on TIMESTAMPTZ NOT NULL DEFAULT (current_timestamp + interval '30' day)
);