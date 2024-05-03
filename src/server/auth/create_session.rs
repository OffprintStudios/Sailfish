use chrono::{Months, Utc};
use sea_orm::ActiveValue::Set;
use sea_orm::DatabaseConnection;
use uuid::Uuid;
use crate::server::db::entities::*;

pub async fn create_session(conn: &DatabaseConnection, account_id: Uuid) {
    let new_session = session::ActiveModel {
        account_id: Set(account_id),
        ip_addr: Set(None),
        browser: Set(None),
        device: Set(None),
        os: Set(None),
        expiration: Set(Utc::now().checked_add_months(Months::new(1)).unwrap().fixed_offset()),
        ..Default::default()
    };
}