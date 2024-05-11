use crate::client::util::filters::RatingFilter;
use crate::client::util::modes::Mode;
use crate::client::util::themes::Theme;

#[derive(Debug, Clone)]
pub struct AppState {
    pub theme: Theme,
    pub mode: Mode,
    pub age_check: bool,
    pub rating_filter: RatingFilter,
}

impl AppState {
    fn sync() {
        
    }
}