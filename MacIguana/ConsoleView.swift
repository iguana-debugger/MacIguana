//
//  ConsoleView.swift
//  MacIguana
//
//  Created by James on 04/12/2023.
//

import SwiftUI

struct ConsoleView: View {
    @Binding public var terminal: [UInt8]
    
    /// A callback that passes up the terminal's `send` output. Pre-formatted to be Komodo-compatible.
    public let onSend: (_ data: [UInt8]) -> ()
    
    var body: some View {
        JimulatorTerminalAdapter(terminal: $terminal, onSend: onSend)
    }
}
