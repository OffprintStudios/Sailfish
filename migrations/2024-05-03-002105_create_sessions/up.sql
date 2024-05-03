-- Your SQL goes here
CREATE TABLE sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    account_id UUID NOT NULL REFERENCES accounts (id),
    ip_addr VARCHAR(32) DEFAULT null,
    browser VARCHAR(32) DEFAULT null,
    device VARCHAR(32) DEFAULT null,
    os VARCHAR(32) DEFAULT null,
    created_at TIMESTAMPTZ NOT NULL DEFAULT current_timestamp,
    expiration TIMESTAMPTZ NOT NULL
);
