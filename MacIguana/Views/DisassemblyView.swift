//
//  DisassemblyView.swift
//  MacIguana
//
//  Created by James on 04/12/2023.
//

import SwiftUI
import TipKit
import Libiguana

private struct DisassemblyViewTip: Tip {
    var title: Text {
        Text("Disassembly")
    }
    
    var message: Text? {
        Text("View what the assembler outputted, and set breakpoints")
    }
}

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
    
    public let pc: UInt32
    
    public let traps: [UInt32 : UInt8]
    
    public let onToggleBreakpoint: (UInt32, Bool) -> ()
    
    private var lineIndexes: [IndexedKmdparseLine] {
        lines.enumerated().map { .init(offset: $0.offset, element: $0.element) }
    }
    
    var body: some View {
        Table(lineIndexes) {
            TableColumn("") { line in
                if let memoryAddress = line.element.memoryAddress {
                    BreakpointButton(isOn: .init(get: { traps[memoryAddress] != nil }, set: { isSet in
                        onToggleBreakpoint(memoryAddress, isSet)
                    }))
                    .accessibilityLabel("Set breakpoint")
                }
            }
            .width(10)
            .alignment(.center)
            TableColumn("Address") { line in
                if let memoryAddress = line.element.memoryAddress {
                    let hex = String(format: "%08X", memoryAddress)
                    Text(hex)
                        .monospaced()
                        .speechSpellsOutCharacters()
                        .foregroundStyle(line.element.word?.isInstruction ?? false && memoryAddress == pc ? .green : .primary)
                }
            }
            .width(70)
            TableColumn("Hex") { line in
                if let word = line.element.word {
                    Text(word.hex)
                        .monospaced()
                        .speechSpellsOutCharacters()
                        .foregroundStyle(line.element.word?.isInstruction ?? false && line.element.memoryAddress == pc ? .green : .primary)
                }
            }
            .width(80)
            TableColumn("String") {line in
                if let string = line.element.word?.string {
                    Text(string)
                        .monospaced()
                        .speechSpellsOutCharacters()
                        .foregroundStyle(line.element.word?.isInstruction ?? false && line.element.memoryAddress == pc ? .green : .primary)
                }
            }
            .width(40)
            TableColumn("Disassembly") { line in
                Text(line.element.comment)
                    .monospaced()
                    .foregroundStyle(line.element.word?.isInstruction ?? false && line.element.memoryAddress == pc ? .green : .primary)
            }
        }
        .accessibilityLabel("Disassembly")
        .popoverTip(DisassemblyViewTip(), arrowEdge: .trailing)
    }
}

#Preview {
    DisassemblyView(
        lines: [
            .init(memoryAddress: 0, word: .instruction(instruction: 0), comment: "Comment"),
            .init(memoryAddress: 0xDEADBEEF, word: .instruction(instruction: 0xDEADBEEF), comment: "Comment")
        ],
        pc: 0xDEADBEEF,
        traps: [0xDEADBEEF: 1]
    ) { _, _ in }
}
