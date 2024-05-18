use serde::{Deserialize, Serialize};
use crate::models::util::{RatingFilter, BrightnessMode, Theme};

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
pub struct AppState {
    pub theme: Theme,
    pub brightness_mode: BrightnessMode,
    pub age_check: bool,
    pub rating_filter: RatingFilter,
}

impl Default for AppState {
    fn default() -> Self {
        AppState {
            theme: Theme::Crimson,
            brightness_mode: BrightnessMode::System,
            age_check: false,
            rating_filter: RatingFilter::Restricted,
        }
    }
}