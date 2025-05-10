use serde::{Serialize, Deserialize};

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq, Eq)]
pub enum RatingFilter {
    Restricted,
    MatureOnly,
    ExplicitOnly,
    Everything,
}