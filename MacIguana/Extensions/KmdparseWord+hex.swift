//
//  KmdparseWord+hex.swift
//  MacIguana
//
//  Created by James on 11/03/2024.
//

import Foundation
import Libiguana

extension KmdparseWord {
    /// A hex representation of the word. Note that unlike Komodo, data words won't have spacing :(
    var hex: String {
        switch self {
        case .instruction(instruction: let instructionBytes):
            String(format: "%08X", instructionBytes)
        case .data(data: let data):
            String(format: "%08X", data as CVarArg)
        }
    }
}
