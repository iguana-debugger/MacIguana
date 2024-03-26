//
//  SwiftIguanaEnvironment.swift
//  MacIguana
//
//  Created by James on 21/02/2024.
//

import AppKit
import Foundation
import Libiguana

enum CompileFailedError: Error {
    case aasmFailed(terminal: String)
}

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
    
    var timer: Timer = .init() // We do an empty init here so that we can capture self in init
    
    init(asmPath: URL, includePaths: [String] = []) throws {
        self.environment = try IguanaEnvironment()
        
//        Needed because boardState needs to be set in init
        self.boardState = try environment.status()
        
        let kmd = try self.environment.compileAasm(aasmPath: asmPath.path(percentEncoded: false))
        
        if kmd.aasmTerminal.contains("No output generated.") {
            throw CompileFailedError.aasmFailed(terminal: kmd.aasmTerminal)
        }
        
        try self.environment.loadKmd(kmd: kmd.kmd)
        
        self.currentKmd = self.environment.currentKmd()?.compactMap {
            if case let .line(line) = $0 {
                return line
            }
            return nil
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.05 , repeats: true) { [weak self] timer in
            do {
                self?.registers = try self?.environment.registers() ?? .zero
                self?.boardState = try self?.environment.status() ?? .init(status: .broken, stepsRemaining: 0, stepsSinceReset: 0)
                self?.terminal.append(try self?.environment.terminalMessages() ?? "")
            } catch {
//                If an error has occurred, set the error and cancel the run loop.
//                Errors here should pretty much always be unrecoverable.
                self?.eventLoopError = error
                timer.invalidate()
            }
        }
    }

    deinit {
        timer.invalidate()
    }
}
