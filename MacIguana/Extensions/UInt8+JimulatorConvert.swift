//
//  UInt8+JimulatorConvert.swift
//  MacIguana
//
//  Created by James on 31/03/2024.
//

import Foundation

/// Functions for converting to/from Jimulator for SwiftTerm
extension UInt8 {
    /// Converts a terminal keycode to a Jimulator keycode
    var jimulator: UInt8 {
        switch self {
        case 13: // Newline
            return 10
        case 127: // Backspace
            return 8
        default:
            return self
        }
    }
}
