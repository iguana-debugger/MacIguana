//
//  SwiftIguanaEnvironment.swift
//  MacIguana
//
//  Created by James on 21/02/2024.
//

import AppKit
import Foundation
import Libiguana

/// A wrapper around `IguanaEnvironment` to allow for Observable
@Observable
class SwiftIguanaEnvironment {
    @ObservationIgnored
    let environment: IguanaEnvironment
    
    var registers: Registers = .init(
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
    
    var terminal: String = ""
    
    init() throws {
        self.environment = try IguanaEnvironment()
        
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            self.registers = try! self.environment.registers()
            self.terminal.append(try! self.environment.terminalMessages())
        }
        
        let testKMD = String(decoding: NSDataAsset(name: "hello")!.data, as: UTF8.self)
        
        try self.environment.loadKmd(kmd: testKMD)
        try self.environment.start(steps: 0)
    }
}
