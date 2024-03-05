//
//  Registers+zero.swift
//  MacIguana
//
//  Created by James on 05/03/2024.
//

import Foundation
import Libiguana

extension Registers {
    /// `Registers` with all registers set to zero.
    static let zero = Registers(
        r0: 0,
        r1: 0,
        r2: 0,
        r3: 0,
        r4: 0,
        r5: 0,
        r6: 0,
        r7: 0,
        r8: 0,
        r9: 0,
        r10: 0,
        r11: 0,
        r12: 0,
        r13: 0,
        r14: 0,
        pc: 0
    )
}
