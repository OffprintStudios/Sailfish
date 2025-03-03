-- Add up migration script here
CREATE TABLE IF NOT EXISTS sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    account_id UUID NOT NULL REFERENCES accounts (id) ON DELETE CASCADE,
    ip_addr TEXT DEFAULT NULL,
    browser TEXT DEFAULT NULL,
    device TEXT DEFAULT NULL,
    os TEXT DEFAULT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT current_timestamp,
    expires_on TIMESTAMPTZ NOT NULL DEFAULT (current_timestamp + interval '30' day)
);