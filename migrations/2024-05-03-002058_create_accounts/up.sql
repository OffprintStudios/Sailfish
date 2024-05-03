-- Your SQL goes here
CREATE TABLE accounts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(75) UNIQUE NOT NULL,
    password TEXT NOT NULL,
    roles TEXT[] NOT NULL DEFAULT '{"User"}',
    terms_agree BOOLEAN NOT NULL DEFAULT false,
    email_confirmed BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMPTZ NOT NULL DEFAULT current_timestamp,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT current_timestamp
);

SELECT diesel_manage_updated_at('accounts');
