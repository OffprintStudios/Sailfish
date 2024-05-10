use std::sync::OnceLock;
use tower_cookies::Key;

pub static KEY: OnceLock<Key> = OnceLock::new();

/// 30 day expiration time in seconds
pub const MAX_SESSION_DURATION: i64 = 60 * 60 * 24 * 30;

/// 1 day expiration time in seconds
pub const MIN_SESSION_DURATION: i64 = 60 * 60 * 24;