use serde::{Serialize, Deserialize};

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
pub enum RatingFilter {
    Restricted,
    MatureOnly,
    ExplicitOnly,
    Everything,
}