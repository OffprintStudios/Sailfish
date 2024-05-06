DEFINE EVENT set_account_updated_at ON TABLE accounts WHEN $event == "UPDATE" THEN (
    UPDATE accounts SET updated_at = time::now() WHERE id = $after.id
);