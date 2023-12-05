//
//  RegisterView.swift
//  MacIguana
//
//  Created by James on 04/12/2023.
//

import SwiftUI

struct Register: Identifiable {
    let id = UUID()
    
    let name: String
    let value: UInt32
    let ascii = "IGUA"
}

struct RegisterView: View {
    private let registers = [
        Register(name: "R0", value: 0),
        Register(name: "R1", value: 0),
        Register(name: "R2", value: 0),
        Register(name: "R3", value: 0),
        Register(name: "R4", value: 0),
        Register(name: "R5", value: 0),
        Register(name: "R6", value: 0),
        Register(name: "R7", value: 0),
        Register(name: "R8", value: 0),
        Register(name: "R9", value: 0),
        Register(name: "R10", value: 0),
        Register(name: "R11", value: 0),
        Register(name: "R12", value: 0),
        Register(name: "R13", value: 0),
        Register(name: "R14", value: 0),
        Register(name: "PC", value: 0),
        Register(name: "CPSR", value: 0),
        Register(name: "SPSR", value: 0),
    ]
    
    var body: some View {
        Table(registers) {
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
            TableColumn("ASCII") { register in
                Text(register.ascii)
                    .monospaced()
            }
        }
    }
}

#Preview {
    RegisterView()
}
