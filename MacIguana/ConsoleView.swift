//
//  ConsoleView.swift
//  MacIguana
//
//  Created by James on 04/12/2023.
//

import SwiftUI

struct ConsoleView: View {
    @State
    private var text = "Hello World!"
    
    var body: some View {
        TextEditor(text: $text)
            .monospaced()
    }
}

#Preview {
    ConsoleView()
}
