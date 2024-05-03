// @generated automatically by Diesel CLI.

diesel::table! {
    accounts (id) {
        id -> Uuid,
        #[max_length = 75]
        email -> Varchar,
        password -> Text,
        roles -> Array<Nullable<Text>>,
        terms_agree -> Bool,
        email_confirmed -> Bool,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
    }
}

diesel::table! {
    sessions (id) {
        id -> Uuid,
        account_id -> Uuid,
        #[max_length = 32]
        ip_addr -> Nullable<Varchar>,
        #[max_length = 32]
        browser -> Nullable<Varchar>,
        #[max_length = 32]
        device -> Nullable<Varchar>,
        #[max_length = 32]
        os -> Nullable<Varchar>,
        created_at -> Timestamptz,
        expiration -> Timestamptz,
    }
}

diesel::joinable!(sessions -> accounts (account_id));

diesel::allow_tables_to_appear_in_same_query!(
    accounts,
    sessions,
);
