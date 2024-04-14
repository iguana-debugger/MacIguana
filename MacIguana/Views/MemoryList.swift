//
//  MemoryList.swift
//  MacIguana
//
//  Created by James on 01/04/2024.
//

import SwiftUI
import TipKit
import Libiguana

private struct MemoryListTip: Tip {
    var title: Text {
        Text("Memory")
    }
    
    var message: Text? {
        Text("View raw memory in the emulator")
    }
}

extension UInt32: Identifiable {
    public var id: Self {
        self
    }
}

struct MemoryList: View {
    /// The max memory address to show in the list. This is a public static variable because it's used in
    /// `SwiftIguanaEnvironment`.
    public static let maxMemory: UInt32 = 0xFFFF
    
    // I'd rather show all 1MB, but SwiftUI hates having so many rows
    private let addresses: [UInt32] = (0...maxMemory).filter { $0 % 4 == 0 || $0 == maxMemory }
    
    public let values: [UInt32 : UInt32]
    public let pc: UInt32
    
    public let onWatch: (UInt32) -> ()
    public let onUnwatch: (UInt32) -> ()
    
    var body: some View {
        Table(addresses) {
            TableColumn("Address") { address in
                let hex = String(format: "%08X", address)

                Text(hex)
                    .monospaced()
                    .speechSpellsOutCharacters()
                    .foregroundStyle(address == pc ? .green : .primary)
                    .onAppear { onWatch(address) }
                    .onDisappear { onUnwatch(address) }
            }
            .width(70)
            TableColumn("Hex") { address in
                if let value = values[address] {
                    let hex = String(format: "%08X", value)

                    Text(hex)
                        .monospaced()
                        .speechSpellsOutCharacters()
                        .foregroundStyle(address == pc ? .green : .primary)
                }
            }
            .width(80)
            TableColumn("Disassembly") { address in
                if let value = values[address], let decoded = try? decodeInstruction(word: value) {
                    Text(decoded)
                        .monospaced()
                        .speechSpellsOutCharacters()
                        .foregroundStyle(address == pc ? .green : .primary)
                }
            }
        }
        .accessibilityLabel("Memory")
        .popoverTip(MemoryListTip(), arrowEdge: .trailing)
    }
}

#Preview {
    MemoryList(values: [0:0], pc: 0) { _ in
//        
    } onUnwatch: { _ in
//        
    }
}
