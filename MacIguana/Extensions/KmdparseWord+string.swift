//
//  KmdparseWord+string.swift
//  MacIguana
//
//  Created by James on 11/03/2024.
//

import Foundation
import Libiguana

extension KmdparseWord {
    var string: String? {
        switch self {
        case .instruction(instruction: let instruction):
            var mutableBytes = instruction.littleEndian
            return String(bytes: Data(bytes: &mutableBytes, count: 4), encoding: .utf8)
        case .data(data: let data):
            return String(bytes: data, encoding: .utf8)
        }
    }
}
