-- Add up migration script here
CREATE TABLE IF NOT EXISTS message_threads (
    id CHAR(21) PRIMARY KEY DEFAULT nanoid(),
    "name" TEXT NOT NULL,
    sender_id CHAR(21) NOT NULL REFERENCES profiles (id) ON DELETE CASCADE,
    receiver_id CHAR(21) NOT NULL REFERENCES profiles (id) ON DELETE CASCADE,
    read_on TIMESTAMPTZ DEFAULT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT current_timestamp,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT current_timestamp,
    deleted_at TIMESTAMPTZ DEFAULT NULL
);

CREATE TABLE IF NOT EXISTS messages (
    id CHAR(21) PRIMARY KEY DEFAULT nanoid(),
    thread_id CHAR(21) NOT NULL REFERENCES message_threads (id) ON DELETE CASCADE,
    sender_id CHAR(21) NOT NULL REFERENCES profiles (id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT current_timestamp,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT current_timestamp,
    deleted_at TIMESTAMPTZ DEFAULT NULL
);

SELECT manage_updated_at('message_threads');
SELECT manage_updated_at('messages');