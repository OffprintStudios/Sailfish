-- Add up migration script here
CREATE TABLE IF NOT EXISTS confirmation_codes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    account_id UUID NOT NULL REFERENCES accounts (id) ON DELETE CASCADE,
    token VARCHAR(21) NOT NULL DEFAULT nanoid(),
    used BOOLEAN NOT NULL DEFAULT false,
    expires_on TIMESTAMPTZ NOT NULL DEFAULT (current_timestamp + interval '1' hour),
    created_at TIMESTAMPTZ NOT NULL DEFAULT current_timestamp
);