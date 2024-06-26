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

enum RunLoopInterval: TimeInterval {
    case active = 0.05
    case inactive = 0.1
    case minimised = 1
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
    
    var terminalText: String = ""
    
    var timer: Timer = .init() // We do an empty init here so that we can capture self in init
    
    var traps: [UInt32 : UInt8] = [:]
    
    var watchedMemoryAddresses: Set<UInt32> = Set()
    
    /// The current run loop interval for the environment. We keep this so that we can stop/start the timer with the
    /// correct interval.
    var runLoopInterval: RunLoopInterval = .active {
        didSet {
//            If the run loop is running, set it to the new interval
            if timer.isValid {
                createTimer(runLoopInterval)
            }
        }
    }
    
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
        
        createTimer(.active)
    }
    
    /// Initialises this environment's run loop timer, invalidating the previously set one.
    func createTimer(_ interval: RunLoopInterval) {
        timer.invalidate()

        timer = Timer.scheduledTimer(withTimeInterval: interval.rawValue, repeats: true) { [weak self] timer in
            do {
                if let self {
//                    If an error has been thrown from elsewhere, stop the run loop.
                    if self.fatalError != nil {
                        timer.invalidate()
                        return
                    }
                    
                    let previousStatus = self.boardState.status
                    self.boardState = try self.environment.status()
                    
//                    If the board state changes, announce it with VoiceOver
                    if self.boardState.status != previousStatus {
                        var announcement = AttributedString("Emulator \(self.boardState.status.description)")
                        announcement.accessibilitySpeechAnnouncementPriority = .high
                        
                        AccessibilityNotification.Announcement(announcement)
                            .post()
                    }
                    
                    if self.boardState.status == .stopped || self.boardState.status == .finished {
//                        If the program has finished, stop the run loop to save power.
                        timer.invalidate()
                    }
                    
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
                    
                    if let terminalString = String(data: terminal, encoding: .ascii) {
                        for char in terminalString {
                            guard let ascii = char.asciiValue else { continue }
                            
//                            If the character is a backspace, pop a character from the terminal. Otherwise, append
                            if ascii == 8 {
                                let _ = self.terminalText.popLast()
                            } else {
                                self.terminalText.append(char)
                            }
                        }
                    }
                    
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
    
    /// Starts execution, and restarts the timer at the given run loop interval.
    func start(steps: UInt32 = 0) throws {
        try environment.startExecution(steps: steps)
        createTimer(runLoopInterval)
    }

    deinit {
        timer.invalidate()
    }
}
