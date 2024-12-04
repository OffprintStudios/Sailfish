use serde::{Serialize, Deserialize};
use crate::models::util::{
    filters::RatingFilter,
    themes::{Theme, Brightness},
};

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
pub struct AppStore {
    pub theme: Theme,
    pub brightness: Brightness,
    pub age_check: bool,
    pub unblur_blogs: bool,
    pub rating_filter: RatingFilter,
}

impl Default for AppStore {
    fn default() -> Self {
        AppStore {
            theme: Theme::Crimson,
            brightness: Brightness::System,
            age_check: false,
            unblur_blogs: false,
            rating_filter: RatingFilter::Restricted,
        }
    }
}