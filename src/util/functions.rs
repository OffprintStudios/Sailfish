use crate::models::accounts::Role;

/// Determines the most prominent role in an array of roles
pub fn get_prominent_role(roles: Vec<Role>) -> Role {
    match roles.iter().min().copied() {
        Some(role) => role,
        None => Role::User
    }
}