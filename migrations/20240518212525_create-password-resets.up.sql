-- Add up migration script here
CREATE TABLE IF NOT EXISTS password_resets (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    account_id UUID NOT NULL REFERENCES accounts (id),
    token VARCHAR(21) NOT NULL DEFAULT nanoid(),
    expires_on TIMESTAMPTZ NOT NULL DEFAULT (current_timestamp + interval '1' hour),
    created_at TIMESTAMPTZ NOT NULL DEFAULT current_timestamp
);