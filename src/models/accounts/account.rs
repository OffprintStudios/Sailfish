use argon2::{Argon2, password_hash::{rand_core::OsRng, SaltString}, PasswordHasher};

pub struct Account {
    pub id: String,
    pub email: String,
    pub password: String,
    pub terms_agree: bool,
    pub email_confirmed: bool,
    pub created_at: String,
    pub updated_at: String,
}

impl Account {
    pub fn init(form_info: RegisterForm) -> Self {
        Account {
            id: "uuid".to_string(),
            email: form_info.email,
            password: Self::hash_password(form_info.password),
            terms_agree: form_info.terms_agree,
            email_confirmed: false,
            created_at: Default::default(),
            updated_at: Default::default(),
        }
    }
    
    fn hash_password(password: String) -> String {
        let argon2 = Argon2::default();
        let pw = password.as_bytes();
        let salt = SaltString::generate(&mut OsRng);
        let hash = argon2.hash_password(pw, &salt);
        hash.unwrap().to_string() // TODO: handle potential errors better
    }
}

pub struct RegisterForm {
    pub email: String,
    pub password: String,
    pub age_check: bool,
    pub terms_agree: bool,
}