use uuid::Uuid;
use sqlx::{Pool, Postgres};
use tower_cookies::PrivateCookies;
use crate::server::db::accounts::{Account, Session, Profile};

pub async fn authorize<'a>(cookies: PrivateCookies<'a>, db: &Pool<Postgres>) -> Option<Account> {
    let session_token = cookies.get("session_token")?;
    let session_id = Uuid::parse_str(session_token.value()).ok()?;

    let account_id = Session::verify_session(session_id, db).await.ok()?;
    
    Account::fetch_by_id(account_id, db).await.ok()?
}

pub async fn authorize_with_profile<'a>(cookies: PrivateCookies<'a>, profile_id: String, db: &Pool<Postgres>) -> Option<(Account, Profile)> {
    let account = authorize(cookies, db).await?;
    let profile = Profile::check_owned(profile_id, account.id, db).await.ok()?;

    Some((account, profile))
}