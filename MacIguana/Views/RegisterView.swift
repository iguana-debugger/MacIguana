//
//  RegisterView.swift
//  MacIguana
//
//  Created by James on 04/12/2023.
//

import SwiftUI
import TipKit
import Libiguana

private struct RegisterViewTip: Tip {
    var title: Text {
        Text("Registers")
    }
    
    var message: Text? {
        Text("View register state")
    }
}

struct RegisterView: View {
    public let registers: Registers
    
    var body: some View {
        Table(registers.list) {
            TableColumn("Register") { register in
                Text(register.name)
                    .monospaced()
                    .speechSpellsOutCharacters()
            }
            .width(50)
            TableColumn("Value") { register in
                let hex = String(format: "%08X", register.value)
                Text(hex)
                    .monospaced()
                    .speechSpellsOutCharacters()
            }
            .width(70)
            TableColumn("String") { register in
                Text(register.string)
                    .monospaced()
                    .speechSpellsOutCharacters()
            }
//            .width(70)
        }
        .accessibilityLabel("Registers")
        .popoverTip(RegisterViewTip(), arrowEdge: .leading)
    }
}

#Preview {
    RegisterView(registers: .zero)
}
