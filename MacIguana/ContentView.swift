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
                    DisassemblyView()
                }
                ConsoleView()
            }
            BoardStatePane(boardState: iguanaEnvironment.boardState)
                .safeAreaPadding(.zero)
        }
        .toolbar(id: "main") {
            ToolbarItem(id: "Reset") {
                Button("Reset", systemImage: "arrow.clockwise") {
                    try? iguanaEnvironment.environment.reset()
                }
            }
            ToolbarItem(id: "Stop") {
                Button("Stop", systemImage: "stop.fill") {
                    try? iguanaEnvironment.environment.stopExecution()
                }
            }
            ToolbarItem(id: "RunPause") {
                if iguanaEnvironment.boardState.status == .running {
                    Button("Pause", systemImage: "pause.fill") {
                        try? iguanaEnvironment.environment.pause()
                    }
                } else {
                    Button("Run", systemImage: "play.fill") {
                        let status = iguanaEnvironment.boardState.status
                        
                        if status == .normal || status == .stopped {
                            try? iguanaEnvironment.environment.startExecution(steps: 0)
                        } else {
                            try? iguanaEnvironment.environment.continueExecution()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
