//
//  MemoryList.swift
//  MacIguana
//
//  Created by James on 01/04/2024.
//

import SwiftUI
import Libiguana

extension UInt32: Identifiable {
    public var id: Self {
        self
    }
}

struct MemoryList: View {
    private let addresses: [UInt32] = (0...0xFFFF).filter { $0 % 4 == 0 }
    
    public let values: [UInt32 : UInt32]
    
    public let onWatch: (UInt32) -> ()
    public let onUnwatch: (UInt32) -> ()
    
    var body: some View {
        Table(addresses) {
            TableColumn("Address") { address in
                let hex = String(format: "%08X", address)

                Text(hex)
                    .monospaced()
                    .onAppear { onWatch(address) }
                    .onDisappear { onUnwatch(address) }
            }
            .width(70)
            TableColumn("Hex") { address in
                if let value = values[address] {
                    let hex = String(format: "%08X", value)

                    Text(hex)
                        .monospaced()
                }
            }
            .width(80)
            TableColumn("Disassembly") { address in
                if let value = values[address], let decoded = try? decodeInstruction(word: value) {
                    Text(decoded)
                        .monospaced()
                }
            }
        }
    }
}

#Preview {
    MemoryList(values: [0:0]) { _ in
//        
    } onUnwatch: { _ in
//        
    }
}
