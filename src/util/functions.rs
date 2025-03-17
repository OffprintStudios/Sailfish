use std::fmt::Display;
use serde::{Serialize, Deserialize};
use chrono::{DateTime, Local, Utc};
use crate::models::accounts::Role;

/// Determines the most prominent role in an array of roles
pub fn get_prominent_role(roles: Vec<Role>) -> Role {
    roles.iter().min().copied().unwrap_or(Role::User)
}

/// Abbreviates a number for better readability.
pub fn abbreviate<T>(number: T) -> String
where 
    T: Copy + Display + PartialOrd,
    T: std::ops::Div<Output = T>,
    T: std::ops::Rem<Output = T>,
    T: From<i32>,
{
    let hundred = T::from(100);
    let thousand = T::from(1000);
    let ten_thousand = T::from(10_000);

    if number < thousand {
        return number.to_string();
    }

    if number < ten_thousand {
        let whole_part = number / thousand;
        let decimal_part = (number % thousand) / hundred;
        
        if decimal_part == T::from(0) {
            return format!("{}k", whole_part);
        } else {
            return format!("{}.{}k", whole_part, decimal_part);
        }
    }

    let thousands = number / thousand;
    format!("{}k", thousands)
}

/// Determines whether or not to add an `s` at the end of a word to pluralize it
pub fn pluralize<T>(number: T) -> String
where 
    T: Copy + Display + PartialOrd,
    T: std::ops::Div<Output = T>,
    T: std::ops::Rem<Output = T>,
    T: From<i32>,
{
    match number == T::from(1) {
        true => "".into(),
        false => "s".into()
    }
}

#[derive(Debug, Clone, Copy, Serialize, Deserialize)]
pub enum DateFormat {
    Short,
    ShortDate,
    ShortTime,
    Medium,
    MediumDate,
    MediumTime,
    Long,
    LongDate,
    LongTime,
    Full,
    FullDate,
    FullTime,
}

/// Formats the date to the user's local time.
pub fn locale_date(value: DateTime<Utc>, format: DateFormat) {
    let date: DateTime<Local> = DateTime::from(value);
}