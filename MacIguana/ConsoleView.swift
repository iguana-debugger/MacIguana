//
//  ConsoleView.swift
//  MacIguana
//
//  Created by James on 04/12/2023.
//

import SwiftUI

struct ConsoleView: View {
    @Environment(SwiftIguanaEnvironment.self) private var iguanaEnvironment
    
    var body: some View {
        TextEditor(text: .constant(iguanaEnvironment.terminal))
            .monospaced()
    }
}

#Preview {
    ConsoleView()
}
