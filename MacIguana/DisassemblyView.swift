//
//  DisassemblyView.swift
//  MacIguana
//
//  Created by James on 04/12/2023.
//

import SwiftUI
import Libiguana

/// `KmdParseLine`, with the associated offset. We do this to get `Identifiable` conformance. I did try using
/// `KmdparseLine`'s `hashValue`, but of course identical lines caused issues.
///
/// This struct could probably be made generic :)
struct IndexedKmdparseLine: Identifiable {
    var id: Int {
        offset.hashValue ^ element.hashValue
    }
    
    let offset: Int
    let element: KmdparseLine
}

struct DisassemblyView: View {
    public let lines: [KmdparseLine]
    
    private var lineIndexes: [IndexedKmdparseLine] {
        lines.enumerated().map { .init(offset: $0.offset, element: $0.element) }
    }
    
    var body: some View {
        Table(lineIndexes) {
            TableColumn("Address") { line in
                if let memoryAddress = line.element.memoryAddress {
                    let hex = String(format: "%08X", memoryAddress)
                    Text(hex)
                        .monospaced()
                }
            }
            .width(70)
            TableColumn("Hex") { line in
                if let word = line.element.word {
                    Text(word.hex)
                        .monospaced()
                }
            }
            .width(80)
            TableColumn("String") {line in
                if let string = line.element.word?.string {
                    Text(string)
                        .monospaced()
                }
            }
            .width(40)
            TableColumn("Disassembly") { line in
                Text(line.element.comment)
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
