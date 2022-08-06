//
// Created by Alyx Mote on 7/30/22.
//

import Foundation

/// A long session is effectively 7 days, calculated as Seconds * Minutes * Hours * Days
let LONG_SESSION: TimeInterval = 60.0 * 60.0 * 24.0 * 7.0

/// A short session is one 24-hour cycle, calculated as Seconds * Minutes * Hours * Days
let SHORT_SESSION: TimeInterval = 60.0 * 60.0 * 24.0 * 1.0

/// The number of characters for NanoID generation
let NANO_ID_SIZE: Int = 7
