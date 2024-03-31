//
//  UInt8+JimulatorConvert.swift
//  MacIguana
//
//  Created by James on 31/03/2024.
//

import Foundation
import SwiftTerm

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
    
    /// Converts a Jimulator keycode to a terminal keycode
    func terminal(_ xpos: Int) -> [UInt8] {
        switch self {
        case 8: // Backspace
            if xpos == 0 {
                return [27, 77] + EscapeSequences.moveEndNormal + [8, 127, 8] // ESC M, end, followed by backspace
            } else {
                return [8, 127, 8]
            }
        default:
            return [self]
        }
    }
}
