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
    
    var eventLoopError: Error?
    
    var registers = Registers.zero
    
    var boardState: BoardState
    
    var terminal: String = ""
    
    init() throws {
        self.environment = try IguanaEnvironment()
        self.boardState = try environment.status()
        
        Timer.scheduledTimer(withTimeInterval: 0.05 , repeats: true) { timer in
            do {
                self.registers = try self.environment.registers()
                self.boardState = try self.environment.status()
                
                self.terminal.append(try self.environment.terminalMessages())
            } catch {
//                If an error has occured, set the error and cancel the run loop.
//                Errors here should pretty much always be unrecoverable.
                self.eventLoopError = error
                timer.invalidate()
            }
        }
        
        let testKMD = String(decoding: NSDataAsset(name: "hello")!.data, as: UTF8.self)
        
        try self.environment.loadKmd(kmd: testKMD)
        try self.environment.start(steps: 0)
    }
}
