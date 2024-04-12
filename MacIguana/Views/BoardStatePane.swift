//
//  BoardStatePane.swift
//  MacIguana
//
//  Created by James on 05/03/2024.
//

import SwiftUI
import Libiguana

struct BoardStatePane: View {
    public let boardState: BoardState
    
    var body: some View {
        HStack {
            Text(boardState.status.description)
            Spacer()
            Text("Steps Since Reset: \(boardState.stepsSinceReset)")
                .monospacedDigit()
        }
        .accessibilityLabel("Emulator state")
        .accessibilityValue("State: \(boardState.status.description), Steps Since Reset: \(boardState.stepsSinceReset)")
    }
}

#Preview {
    BoardStatePane(boardState: .init(status: .running, stepsRemaining: 100, stepsSinceReset: 0))
}
