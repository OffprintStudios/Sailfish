//
// Created by Alyx Mote on 7/30/22.
//

import Foundation

/// A long session is effectively 30 days, calculated as Seconds * Minutes * Hours * Days
let SESSION_EXPIRATION: TimeInterval = 60.0 * 60.0 * 24.0 * 30.0

/// A short session is one 24-hour cycle, calculated as Seconds * Minutes * Hours * Days
let TOKEN_EXPIRATION: TimeInterval = 60.0 * 60.0 * 24.0 * 1.0

/// The number of characters for NanoID generation
let NANO_ID_SIZE: Int = 10

/// Sets the maximum number of profiles allowed per-account
let MAX_PROFILE_LIMIT: Int = 3

/// A generic error message for things that should be obfuscated by obscurity
let GENERIC_ERROR_MESSAGE: String = "Something went wrong! Try again in a little bit."
