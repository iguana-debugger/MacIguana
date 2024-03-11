//
//  DisassemblyView.swift
//  MacIguana
//
//  Created by James on 04/12/2023.
//

import SwiftUI
import Libiguana

struct DisassemblyView: View {
    public let lines: [KmdparseLine]
    
    var body: some View {
        Table(lines) {
            TableColumn("Address") { line in
                if let memoryAddress = line.memoryAddress {
                    let hex = String(format: "%08X", memoryAddress)
                    Text(hex)
                        .monospaced()
                }
            }
            .width(70)
            TableColumn("Hex") { line in
                if let word = line.word {
                    Text(word.hex)
                        .monospaced()
                }
            }
            .width(80)
            TableColumn("String") {line in
                if let string = line.word?.string {
                    Text(string)
                        .monospaced()
                }
            }
            .width(40)
            TableColumn("Disassembly") { line in
                Text(line.comment)
                    .monospaced()
            }
        }
    }
}

#Preview {
    DisassemblyView(lines: [
        .init(memoryAddress: 0xDEADBEEF, word: .instruction(instruction: 0xDEADBEEF), comment: "Comment")
    ])
}
