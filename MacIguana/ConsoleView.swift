//
//  ConsoleView.swift
//  MacIguana
//
//  Created by James on 04/12/2023.
//

import SwiftUI

struct ConsoleView: View {
    @Binding public var terminal: [UInt8]
    
    public let onSend: (_ data: ArraySlice<UInt8>) -> ()
    
    var body: some View {
        JimulatorTerminalAdapter(terminal: $terminal, onSend: onSend)
    }
}
