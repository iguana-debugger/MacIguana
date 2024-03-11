//
//  ContentView.swift
//  MacIguana
//
//  Created by James on 24/10/2023.
//

import SwiftUI

struct ContentView: View {
    @Environment(SwiftIguanaEnvironment.self) private var iguanaEnvironment
    
    var body: some View {
        VStack {
            VSplitView {
                HSplitView {
                    RegisterView(registers: iguanaEnvironment.registers)
                        .frame(maxWidth: 300)
                    DisassemblyView(lines: iguanaEnvironment.currentKmd ?? [])
                }
                .layoutPriority(1)
                ConsoleView()
                    .frame(minHeight: 200)
            }
            BoardStatePane(boardState: iguanaEnvironment.boardState)
                .padding(.bottom, 4)
                .padding(.horizontal, 10)
        }
        .toolbar(id: "main") {
            ToolbarItem(id: "Reset") {
                Button("Reset", systemImage: "arrow.clockwise") {
                    try? iguanaEnvironment.environment.reset()
                }
//                .keyboardShortcut("r")
            }
            ToolbarItem(id: "Stop") {
                Button("Stop", systemImage: "stop.fill") {
                    try? iguanaEnvironment.environment.stopExecution()
                }
                .disabled(iguanaEnvironment.boardState.status == .stopped)
                .keyboardShortcut(".")
            }
            ToolbarItem(id: "Run") {
                Button("Run", systemImage: "play.fill") {
                    let status = iguanaEnvironment.boardState.status
                    
                    if status == .normal || status == .stopped {
                        try? iguanaEnvironment.environment.startExecution(steps: 0)
                    } else {
                        try? iguanaEnvironment.environment.continueExecution()
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
