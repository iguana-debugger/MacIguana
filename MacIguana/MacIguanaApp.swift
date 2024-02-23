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
            } else {
                Text("Startup failed :( Error was \(startupError.debugDescription)")
                    .onAppear {
                        do {
                            environment = try SwiftIguanaEnvironment()
                        } catch {
                            startupError = error
                        }
                    }
            }
        }
    }
}
