#[derive(Debug, Clone)]
pub enum RatingFilter {
    Restricted,
    MatureOnly,
    ExplicitOnly,
    Everything,
}