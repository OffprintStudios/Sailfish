use std::fmt::Formatter;
use serde::{Serialize, Deserialize};

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
pub enum BrightnessMode {
    Light,
    Dark,
    System,
}

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
pub enum Theme {
    Crimson,
    Aqua,
    Royal,
    Autumn,
    Field,
}

impl std::fmt::Display for BrightnessMode {
    fn fmt(&self, f: &mut Formatter<'_>) -> std::fmt::Result {
        match self {
            BrightnessMode::Light => write!(f, "light"),
            BrightnessMode::Dark => write!(f, "dark"),
            BrightnessMode::System => write!(f, ""),
        }
    }
}

impl From<Theme> for String {
    fn from(value: Theme) -> Self {
        match value {
            Theme::Crimson => String::from("crimson"),
            Theme::Aqua => String::from("aqua"),
            Theme::Royal => String::from("royal"),
            Theme::Autumn => String::from("autumn"),
            Theme::Field => String::from("field"),
        }
    }
}

impl std::fmt::Display for Theme {
    fn fmt(&self, f: &mut Formatter<'_>) -> std::fmt::Result {
        match self {
            Theme::Crimson => write!(f, "crimson"),
            Theme::Aqua => write!(f, "aqua"),
            Theme::Royal => write!(f, "royal"),
            Theme::Autumn => write!(f, "autumn"),
            Theme::Field => write!(f, "field"),
        }
    }
}