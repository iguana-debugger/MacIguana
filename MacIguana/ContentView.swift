//
//  ContentView.swift
//  MacIguana
//
//  Created by James on 24/10/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                RegisterView()
                Divider()
                DisassemblyView()
            }
            Divider()
            ConsoleView()
        }
        .toolbar(id: "main") {
            ToolbarItem(id: "Stop", placement: .primaryAction) {
                Button("Stop", systemImage: "stop.fill") {}
            }
            ToolbarItem(id: "Run", placement: .primaryAction) {
                Button("Run", systemImage: "play.fill") {}
            }
        }
    }
}

#Preview {
    ContentView()
}
