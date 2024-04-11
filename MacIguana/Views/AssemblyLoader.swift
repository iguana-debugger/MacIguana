//
//  AssemblyLoader.swift
//  MacIguana
//
//  Created by James on 19/03/2024.
//

import SwiftUI
import Libiguana

struct AssemblyLoader: View {
    public let url: URL
    
    @Environment(\.dismissWindow) private var dismissWindow
    
    @State private var environment: SwiftIguanaEnvironment?
    @State private var startupError: String?
    @State private var startUpErrorHeight = 0.0
    
    private func loadEnvironment() {
        do {
            environment = try SwiftIguanaEnvironment(asmPath: url)
        } catch CompileFailedError.aasmFailed(let terminal) {
            startupError = terminal
        } catch {
            startupError = error.localizedDescription
        }
    }
    
    var body: some View {
        if let environment {
            if let fatalError = environment.fatalError {
                let errorText = if let iguanaError = fatalError as? LibiguanaError {
                    iguanaError.errorDescription ?? "No description"
                } else {
                    fatalError.localizedDescription
                }
                
                let errorMessage: LocalizedStringKey = """
                \(errorText)
                
                Please restart MacIguana. If this error occurs repeatedly, [open an issue](https://github.com/iguana-debugger/MacIguana/issues).
                """

                ContentUnavailableView {
                    Label("Fatal Error", systemImage: "exclamationmark.octagon.fill")
                } description: {
                    Text(errorMessage)
                }
            } else {
                ContentView(environment: environment) {
                    loadEnvironment()
                }
                .onReceive(NotificationCenter.default.publisher(for: NSApplication.willTerminateNotification), perform: { _ in
                    try? environment.environment.killJimulator()
                })
                .onReceive(NotificationCenter.default.publisher(for: NSApplication.willBecomeActiveNotification), perform: { _ in
                    environment.runLoopInterval = .active
                })
                .onReceive(NotificationCenter.default.publisher(for: NSApplication.didResignActiveNotification), perform: { _ in
                    environment.runLoopInterval = .inactive
                })
//                .onReceive(NotificationCenter.default.publisher(for: NSWindow.didMiniaturizeNotification), perform: { _ in
//                    print("Miniaturised!")
//                    environment.createTimer(.minimised)
//                })
            }
        } else if let startupError {
            ScrollView {
                Group {
                    ContentUnavailableView(
                        "Failed to load",
                        systemImage: "exclamationmark.triangle.fill"
                    )
                    Text(startupError)
                        .monospaced()
                    Button("Reload", systemImage: "arrow.clockwise") {
                        loadEnvironment()
                    }
                }
                .overlay {
                    GeometryReader { geo in
                        Color.clear.onAppear {
                            startUpErrorHeight = geo.size.height
                        }
                    }
                }
            }
            .scrollBounceBehavior(.basedOnSize)
            .frame(maxHeight: startUpErrorHeight)
        } else {
            ProgressView()
                .onAppear {
                    loadEnvironment()
                }
        }
    }
}
