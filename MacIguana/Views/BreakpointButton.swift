//
//  BreakpointButton.swift
//  MacIguana
//
//  Created by James on 02/04/2024.
//

import SwiftUI

struct BreakpointButton: View {
    @Binding public var isOn: Bool
    
    var body: some View {
        Toggle("Breakpoint", isOn: $isOn)
            .toggleStyle(.breakpoint)
    }
}

struct BreakpointToggleStyle: ToggleStyle {
    @State private var isHovering = false
    
    func makeBody(configuration: Configuration) -> some View {
        let style: Color = if configuration.isOn {
            .red
        } else if isHovering {
            .gray
        } else {
            .clear
        }
        
        Button {
            configuration.isOn.toggle()
        } label: {
            Circle()
                .foregroundStyle(style)
                .frame(minWidth: 10, minHeight: 10)
        }
        .buttonStyle(PlainButtonStyle())
        .contentShape(.circle)
        .onHover { isHovering = $0 }
    }
}

extension ToggleStyle where Self == BreakpointToggleStyle {
    static var breakpoint: BreakpointToggleStyle { .init() }
}


#Preview {
//    BreakpointButton(isOn: .constant(true))
//        .padding(100)
    DisassemblyView(
        lines: [
            .init(memoryAddress: 0, word: .instruction(instruction: 0), comment: "Comment"),
            .init(memoryAddress: 0xDEADBEEF, word: .instruction(instruction: 0xDEADBEEF), comment: "Comment")
        ],
        pc: 0xDEADBEEF,
        traps: [0xDEADBEEF: 1]
    ) { _, _ in }
}
