use leptos::*;
use crate::client::models::accounts::ProfileModel;

#[server]
pub async fn load_profiles() -> Result<Vec<ProfileModel>, ServerFnError> {
    use leptos_axum::extract;
    use tower_cookies::Cookies;
    use crate::server::api::auth::authorize;
    use crate::server::db::accounts::Profile;
    use crate::server::util::constants::KEY;
    use crate::server::util::state::SailfishState;

    let key = KEY.get().unwrap();
    let state = expect_context::<SailfishState>();
    let cookies = extract::<Cookies>().await?.private(key);
    
    let account = authorize(cookies, &state.db).await?;
    
    let profiles = Profile::fetch_owned(account.id, &state.db).await?;
    
    let mut profile_models = Vec::new();
    for profile in profiles {
        profile_models.push(ProfileModel::from(profile));
    }
    
    Ok(profile_models)
}

#[component]
pub fn SwitchProfile() -> impl IntoView {}