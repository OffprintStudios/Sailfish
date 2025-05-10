-- Add up migration script here
CREATE TABLE IF NOT EXISTS otp (
    id CHAR(21) PRIMARY KEY DEFAULT nanoid(),
    account_id UUID NOT NULL REFERENCES accounts (id) ON DELETE CASCADE,
    kind TEXT NOT NULL,
    expires_on TIMESTAMPTZ NOT NULL DEFAULT (current_timestamp + interval '1' hour),
    created_at TIMESTAMPTZ NOT NULL DEFAULT current_timestamp
);
