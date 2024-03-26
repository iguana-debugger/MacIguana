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
                        .frame(maxWidth: 250)
                    DisassemblyView(lines: environment.currentKmd ?? [])
                }
                .layoutPriority(1)
                ConsoleView(environment: environment)
                    .frame(minHeight: 200)
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
