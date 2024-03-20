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
    
    init(asmPath: URL, includePaths: [String] = []) throws {
        self.environment = try IguanaEnvironment()
        
//        Needed because boardState needs to be set in init
        self.boardState = try environment.status()
        
        let kmd = try self.environment.compileAasm(aasmPath: asmPath.path(percentEncoded: false))
        
        try self.environment.loadKmd(kmd: kmd.kmd)
        
        self.currentKmd = self.environment.currentKmd()?.compactMap {
            if case let .line(line) = $0 {
                return line
            }
            return nil
        }
        
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
    }
}
