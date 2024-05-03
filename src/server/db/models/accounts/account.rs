use diesel::prelude::*;
use uuid::Uuid;
use chrono::{DateTime, Utc};

#[derive(Queryable, Selectable)]
#[diesel(table_name = crate::server::db::schema::accounts)]
#[diesel(check_for_backend(diesel::pg::Pg))]
pub struct Account {
    pub id: Uuid,
    pub email: String,
    pub password: String,
    pub roles: Vec<Option<String>>,
    pub terms_agree: bool,
    pub email_confirmed: bool,
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
}

#[derive(Insertable)]
#[diesel(table_name = crate::server::db::schema::accounts)]
pub struct NewAccount<'a> {
    pub email: &'a str,
    pub password: &'a str,
    pub roles: Vec<Option<&'a str>>,
    pub terms_agree: bool,
    pub email_confirmed: bool,
}
