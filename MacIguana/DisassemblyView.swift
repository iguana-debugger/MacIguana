//
//  DisassemblyView.swift
//  MacIguana
//
//  Created by James on 04/12/2023.
//

import SwiftUI

struct Instruction: Identifiable {
    let id = UUID()
    
    let address: UInt32
    let value: UInt32
    let disassembly: String?
}

struct DisassemblyView: View {
    private let instructions = [
        Instruction(address: 0, value: 0xEA000007, disassembly: "         B main"),
        Instruction(address: 4, value: 0x48656C6C, disassembly: "hello   DEFB    \"Hello World\\n\",0"),
        Instruction(address: 8, value: 0x6F20576f, disassembly: nil)
    ]
    var body: some View {
        Table(instructions) {
            TableColumn("Address") { instruction in
                let hex = String(format: "%08X", instruction.address)
                Text(hex)
                    .monospaced()
            }
            .width(70)
            TableColumn("Hex") { instruction in
                let hex = String(format: "%08X", instruction.value)
                Text(hex)
                    .monospaced()
            }
            .width(70)
            TableColumn("Disassembly") { instruction in
                Text(instruction.disassembly ?? "")
                    .monospaced()
            }
        }
    }
}

#Preview {
    DisassemblyView()
}
