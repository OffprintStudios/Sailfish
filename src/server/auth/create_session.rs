use chrono::{Days, Utc};
use sea_orm::ActiveValue::Set;
use sea_orm::DatabaseConnection;
use uuid::Uuid;
use crate::server::db::entities::*;

pub async fn create_session(conn: &DatabaseConnection, account_id: Uuid) {
    let session_id = Uuid::new_v4();
    let expiration = Utc::now().checked_add_days(Days::new(30)).unwrap().fixed_offset();
    
    let new_session = session::ActiveModel {
        id: Set(session_id),
        account_id: Set(account_id),
        ip_addr: Set(None),
        browser: Set(None),
        device: Set(None),
        os: Set(None),
        expiration: Set(expiration),
        ..Default::default()
    };
}