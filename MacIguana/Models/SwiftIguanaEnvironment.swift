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
    
    /// An error to be associated with the environment.
    var fatalError: (any Error)?
    
    var memory: [UInt32 : UInt32] = [:]
    
    var registers = Registers.zero
    
    var terminal: [UInt8] = []
    
    var timer: Timer = .init() // We do an empty init here so that we can capture self in init
    
    var traps: [UInt32 : UInt8] = [:]
    
    var watchedMemoryAddresses: Set<UInt32> = Set()
    
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
                if let self {
//                    If an error has been thrown from elsewhere, stop the run loop.
                    if self.fatalError != nil {
                        timer.invalidate()
                        return
                    }
                    
                    self.boardState = try self.environment.status()
                    self.registers = try self.environment.registers()
                    
                    if !watchedMemoryAddresses.isEmpty {
//                        We extend the window of watched memory to stop visible flicker when scrolling since new list
//                        items will briefly be shown before their value is fetched
                        
                        let extendBy: UInt32 = 0x40 // 10 addresses each way

                        var extendedWatchedMemory = watchedMemoryAddresses
                        
                        let min = extendedWatchedMemory.min()!
                        let max = extendedWatchedMemory.max()!
                        
                        let minBound = if min < extendBy { UInt32(0) } else { min - extendBy }
                        let maxBound = if max + extendBy > MemoryList.maxMemory { MemoryList.maxMemory } else { max + extendBy }
                        
                        extendedWatchedMemory.formUnion(stride(from: minBound, through: min, by: 4))
                        extendedWatchedMemory.formUnion(stride(from: max, through: maxBound, by: 4))
                        
                        let newMemory = try extendedWatchedMemory.map { ($0, try self.environment.readMemory(address: $0)) }
                            
                        self.memory = Dictionary(uniqueKeysWithValues: newMemory)
                    }
                    
                    let terminal = try self.environment.terminalMessages()
                    
                    let terminalBytes = [UInt8](terminal)
                    self.terminal.append(contentsOf: terminalBytes)
                    
                    self.traps = self.environment.traps()
                }
            } catch {
//                If an error has occurred, set the error and cancel the run loop.
//                Errors here should pretty much always be unrecoverable.
                self?.fatalError = error
                timer.invalidate()
            }
        }
    }

    deinit {
        timer.invalidate()
    }
}
