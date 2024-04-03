//
//  ContentView.swift
//  MacIguana
//
//  Created by James on 24/10/2023.
//

import SwiftUI

struct ContentView: View {
    public let environment: SwiftIguanaEnvironment
    
    /// A callback to a function that reloads the current assembly file.
    public let onReload: () -> ()
    
    var body: some View {
        VStack {
            VSplitView {
                HSplitView {
                    RegisterView(registers: environment.registers)
                        .frame(width: 300)
                    VSplitView {
                        DisassemblyView(lines: environment.currentKmd ?? [], pc: environment.registers.pc, traps: environment.traps) { memoryAddress, isSet in
                            if isSet {
                                try! environment.environment.createBreakpoint(memoryAddress: memoryAddress)
                            } else {
                                try! environment.environment.removeBreakpoint(memoryAddress: memoryAddress)
                            }
                        }
                        MemoryList(values: environment.memory, pc: environment.registers.pc) {
                            environment.watchedMemoryAddresses.insert($0)
                        } onUnwatch: {
                            environment.watchedMemoryAddresses.remove($0)
                        }
                    }
                }
                .layoutPriority(1)
                JimulatorTerminalAdapter(terminal: .init(get: { environment.terminal }, set: { environment.terminal = $0 })) {
                    try! environment.environment.writeToTerminal(message: Data($0))
                }
                .frame(minHeight: 300)
            }
            BoardStatePane(boardState: environment.boardState)
                .padding(.bottom, 4)
                .padding(.horizontal, 10)
        }
        .toolbar(id: "main") {
            ToolbarItem(id: "Reset") {
                Button("Reset", systemImage: "arrow.clockwise") {
                    onReload()
                }
            }
            ToolbarItem(id: "Stop") {
                Button("Stop", systemImage: "stop.fill") {
                    try? environment.environment.stopExecution()
                }
                .disabled(environment.boardState.status == .stopped)
                .keyboardShortcut(".")
            }
            ToolbarItem(id: "Run") {
                Button("Run", systemImage: "play.fill") {
                    let status = environment.boardState.status
                    
                    if status == .normal || status == .stopped {
                        try? environment.environment.startExecution(steps: 0)
                    } else {
                        try? environment.environment.continueExecution()
                    }
                }
                .keyboardShortcut("r")
            }
        }
    }
}

//#Preview {
//    ContentView()
//}
