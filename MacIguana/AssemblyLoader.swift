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
            ContentView(environment: environment) {
                loadEnvironment()
            }
            .alert("Fatal Error", isPresented: .constant(environment.eventLoopError != nil)) {
                Button("Close") {
                    dismissWindow()
                }
            } message: {
                let errorText = if let iguanaError = environment.eventLoopError as? LibiguanaError {
                    iguanaError.errorDescription
                } else {
                    environment.eventLoopError?.localizedDescription
                }
                Text("Iguana has had a fatal error. The error was: \(errorText ?? "no error????").")
            }
            .dialogSeverity(.critical)
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
