//
//  AssemblyLoader.swift
//  MacIguana
//
//  Created by James on 19/03/2024.
//

import SwiftUI

struct AssemblyLoader: View {
    public let document: KomodoDocument
    public let url: URL
    
    @State private var environment: SwiftIguanaEnvironment?
    
    var body: some View {
        if let environment {
            ContentView()
                .environment(environment)
        } else {
            Text("\(url)")
                .onAppear {
                    environment = try? SwiftIguanaEnvironment(asmPath: url, includePaths: document.includePaths)
                }
        }
    }
}
