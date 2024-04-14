//
//  MacIguanaApp.swift
//  MacIguana
//
//  Created by James on 24/10/2023.
//

import SwiftUI
import TipKit
import Libiguana

@main
struct MacIguanaApp: App {
    var body: some Scene {
        DocumentGroup(viewing: KomodoDocument.self) { document in
            if let url = document.fileURL {
                AssemblyLoader(url: url)
                    .task {
                        try? Tips.resetDatastore()
                        
                        try? Tips.configure([
                            .displayFrequency(.immediate),
                            .datastoreLocation(.applicationDefault)
                        ])
                    }
            } else {
                Text("This document doesn't have a URL path for some reason?")
            }
        }
        .defaultSize(width: 1200, height: 800)
    }
}
