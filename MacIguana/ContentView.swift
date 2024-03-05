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
        VSplitView {
            HSplitView {
                RegisterView(registers: iguanaEnvironment.registers)
                DisassemblyView()
            }
            ConsoleView()
        }
        .toolbar(id: "main") {
            ToolbarItem(id: "Stop") {
                Button("Stop", systemImage: "stop.fill") {}
            }
            ToolbarItem(id: "RunPause") {
                Button("Run", systemImage: "play.fill") {}
            }
        }
    }
}

#Preview {
    ContentView()
}
