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
    
    var boardState: BoardState
    
    var currentKmd: [KmdparseLine]?
    
    var eventLoopError: Error?
    
    var registers = Registers.zero
    
    var terminal: String = ""
    
    init() throws {
        self.environment = try IguanaEnvironment()
        self.boardState = try environment.status()
        
        Timer.scheduledTimer(withTimeInterval: 0.05 , repeats: true) { timer in
            do {
                self.registers = try self.environment.registers()
                self.boardState = try self.environment.status()
                self.currentKmd = self.environment.currentKmd()?.compactMap { 
                    if case let .line(line) = $0 {
                        return line
                    }
                    return nil
                }
                
                self.terminal.append(try self.environment.terminalMessages())
            } catch {
//                If an error has occured, set the error and cancel the run loop.
//                Errors here should pretty much always be unrecoverable.
                self.eventLoopError = error
                timer.invalidate()
            }
        }
        
        let testAsm = String(decoding: NSDataAsset(name: "hello")!.data, as: UTF8.self)
        
        let kmd = try self.environment.compileAasm(aasmString: testAsm)
        
        print(kmd.aasmTerminal)
        print(kmd.kmd)
        
        try self.environment.loadKmd(kmd: kmd.kmd)
        try self.environment.startExecution(steps: 0)
    }
}
