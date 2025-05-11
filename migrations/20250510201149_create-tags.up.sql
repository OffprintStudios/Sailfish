-- Add up migration script here
CREATE TABLE IF NOT EXISTS tags (
    id CHAR(21) PRIMARY KEY DEFAULT nanoid(),
    "name" TEXT UNIQUE NOT NULL,
    "desc" TEXT DEFAULT NULL,
    parent_id CHAR(21) REFERENCES tags (id) ON DELETE CASCADE,
    kind TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT current_timestamp,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT current_timestamp
);

SELECT manage_updated_at('tags');