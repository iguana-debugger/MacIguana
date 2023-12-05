//
//  ContentView.swift
//  MacIguana
//
//  Created by James on 24/10/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        HSplitView {
            RegisterView()
            VSplitView {
                DisassemblyView()
                ConsoleView()
            }
        }
        .toolbar(id: "main") {
            ToolbarItem(id: "Stop") {
                Button("Stop", systemImage: "stop.fill") {}
            }
            ToolbarItem(id: "Run") {
                Button("Run", systemImage: "play.fill") {}
            }
        }
    }
}

#Preview {
    ContentView()
}
