use crate::models::accounts::Role;

/// Determines the most prominent role in an array of roles
pub fn get_prominent_role(roles: Vec<Role>) -> Role {
    roles.iter().min().copied().unwrap_or(Role::User)
}