mod filters;
mod themes;
mod slogans;

#[cfg(feature = "ssr")]
mod email;

pub use filters::RatingFilter;
pub use slogans::{DEFAULT_SLOGANS, HALLOWEEN_SLOGANS, HOLIDAY_SLOGANS, EASTER_SLOGANS};
pub use themes::{BrightnessMode, Theme};

#[cfg(feature = "ssr")]
pub use email::{Email, EmailKind};