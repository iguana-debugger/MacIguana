//
//  KmdparseWord+isInstruction.swift
//  MacIguana
//
//  Created by James on 03/04/2024.
//

import Foundation
import Libiguana

extension KmdparseWord {
    var isInstruction: Bool {
        switch self {
        case .instruction:
            true
        default:
            false
        }
    }
}
