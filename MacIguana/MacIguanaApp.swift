//
//  MacIguanaApp.swift
//  MacIguana
//
//  Created by James on 24/10/2023.
//

import SwiftUI
import Libiguana

@main
struct MacIguanaApp: App {
    @State var environment: SwiftIguanaEnvironment?
    @State var startupError: Error?
    
    var body: some Scene {
        WindowGroup {
            if let environment {
                ContentView()
                    .environment(environment)
                    .alert("Fatal Error", isPresented: .constant(environment.eventLoopError != nil)) {
                        Button("Quit") {
                            NSApp.terminate(nil)
                        }
                    } message: {
                        Text("Iguana has had a fatal error. The error was: \(environment.eventLoopError?.localizedDescription ?? "no error????").")
                    }
                    .dialogSeverity(.critical)
            } else if let startupError {
                Text("Startup failed! The error was \(startupError.localizedDescription)")
            } else {
                ProgressView()
                    .onAppear {
                        do {
                            environment = try SwiftIguanaEnvironment()
                        } catch {
                            self.startupError = error
                        }
                    }
            }
        }
    }
}
