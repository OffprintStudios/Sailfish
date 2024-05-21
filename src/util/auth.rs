use leptos::*;
use crate::error_template::SailfishError;

#[server]
pub async fn verify_access() -> Result<(), ServerFnError<SailfishError>> {
    use crate::sailfish::SailfishState;
    use crate::util::auth::authorize;

    let state = expect_context::<SailfishState>();

    match authorize(&state.db).await {
        Some(_) => Ok(()),
        None => Err(ServerFnError::WrappedServerError(SailfishError::Unauthorized))
    }
}

cfg_if::cfg_if! {
    if #[cfg(feature = "ssr")] {
        use leptos_axum::extract;
        use sqlx::{Pool, Postgres};
        use uuid::Uuid;
        use tower_cookies::Cookies;
        use crate::constants::SECRET_KEY;
        use crate::models::accounts::{Account, Session, Profile};
        
        pub async fn authorize(db: &Pool<Postgres>) -> Option<Account> {
            let key = SECRET_KEY.get()?;
            let cookies = extract::<Cookies>().await.ok()?.private(key);
        
            let session_token = cookies.get("session_token")?;
            let session_id = Uuid::parse_str(session_token.value()).ok()?;
        
            let account_id = Session::verify_session(session_id, db).await.ok()?;
        
            Account::fetch_by_id(account_id, db).await
        }
        
        pub async fn authorize_with_profile(profile_id: String, db: &Pool<Postgres>) -> Option<(Account, Profile)> {
            let account = authorize(db).await?;
            let profile = Profile::check_owned(profile_id, account.id, db).await.ok()?;
        
            Some((account, profile))
        }
    }
}
