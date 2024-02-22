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
    @State var environment = try? SwiftIguanaEnvironment()
    
    var body: some Scene {
        WindowGroup {
            if let environment {
                ContentView()
                    .environment(environment)
            } else {
                Text("Startup failed :(")
            }
        }
    }
}
