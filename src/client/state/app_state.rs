use serde::{Deserialize, Serialize};
use crate::client::util::filters::RatingFilter;
use crate::client::util::modes::Mode;
use crate::client::util::themes::Theme;

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
pub struct AppState {
    pub theme: Theme,
    pub mode: Mode,
    pub age_check: bool,
    pub rating_filter: RatingFilter,
}

impl Default for AppState {
    fn default() -> Self {
        AppState {
            theme: Theme::Crimson,
            mode: Mode::System,
            age_check: false,
            rating_filter: RatingFilter::Restricted,
        }
    }
}