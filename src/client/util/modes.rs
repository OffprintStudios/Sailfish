use std::fmt::Formatter;
use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
pub enum Mode {
    Light,
    Dark,
    System,
}

impl std::fmt::Display for Mode {
    fn fmt(&self, f: &mut Formatter<'_>) -> std::fmt::Result {
        match self {
            Mode::Light => write!(f, "light"),
            Mode::Dark => write!(f, "dark"),
            Mode::System => write!(f, ""),
        }
    }
}
