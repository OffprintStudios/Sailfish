use sea_orm::{DeriveActiveEnum, EnumIter};

#[derive(EnumIter, DeriveActiveEnum)]
#[sea_orm(rs_type = "String", db_type = "String(None)")]
pub enum Roles {
    #[sea_orm(string_value = "Admin")]
    Admin,
    #[sea_orm(string_value = "Moderator")]
    Moderator,
    #[sea_orm(string_value = "ChatModerator")]
    ChatModerator,
    #[sea_orm(string_value = "WorkApprover")]
    WorkApprover,
    #[sea_orm(string_value = "Contributor")]
    Contributor,
    #[sea_orm(string_value = "User")]
    User,
}