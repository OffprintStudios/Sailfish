use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
pub enum RatingFilter {
    Restricted,
    MatureOnly,
    ExplicitOnly,
    Everything,
}