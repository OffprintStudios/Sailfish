use std::sync::OnceLock;
use tower_cookies::Key;

/// The secret key for securing session tokens
pub static SECRET_KEY: OnceLock<Key> = OnceLock::new();

/// The minimum session duration time, totalling 1 day as measured in seconds
pub const MIN_SESSION_DURATION: i64 = 60 * 60 * 24;

/// The maximum session duration time, totalling 30 days as measured in seconds
pub const MAX_SESSION_DURATION: i64 = 60 * 60 * 24 * 30;