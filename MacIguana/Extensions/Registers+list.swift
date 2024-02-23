//
//  Registers+list.swift
//  MacIguana
//
//  Created by James on 22/02/2024.
//

import Foundation
import Libiguana

extension Registers {
    var list: [ListRegister] {
        [
            .init(name: "R0", value: self.r0),
            .init(name: "R1", value: self.r1),
            .init(name: "R2", value: self.r2),
            .init(name: "R3", value: self.r3),
            .init(name: "R4", value: self.r4),
            .init(name: "R5", value: self.r5),
            .init(name: "R6", value: self.r6),
            .init(name: "R7", value: self.r7),
            .init(name: "R8", value: self.r8),
            .init(name: "R9", value: self.r9),
            .init(name: "R10",value: self.r10),
            .init(name: "R11",value: self.r11),
            .init(name: "R12",value: self.r12),
            .init(name: "R13",value: self.r13),
            .init(name: "R14",value: self.r14),
            .init(name: "PC", value: self.pc),
        ]
    }
}
