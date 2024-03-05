//
//  RegisterView.swift
//  MacIguana
//
//  Created by James on 04/12/2023.
//

import SwiftUI
import Libiguana

struct RegisterView: View {
    public let registers: Registers
    
    var body: some View {
        Table(registers.list) {
            TableColumn("Register") { register in
                Text(register.name)
                    .monospaced()
            }
            .width(50)
            TableColumn("Value") { register in
                let hex = String(format: "%08X", register.value)
                Text(hex)
                    .monospaced()
            }
            .width(70)
            TableColumn("String") { register in
                Text(register.string)
                    .monospaced()
            }
        }
    }
}

#Preview {
    RegisterView(registers: .zero)
}
