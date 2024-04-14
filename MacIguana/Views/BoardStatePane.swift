//
//  BoardStatePane.swift
//  MacIguana
//
//  Created by James on 05/03/2024.
//

import SwiftUI
import TipKit
import Libiguana

private struct BoardStatePaneTip: Tip {
    var title: Text {
        Text("Board state")
    }
    
    var message: Text? {
        Text("Check the emulator state, and how long it's been running for")
    }
}

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
        .popoverTip(BoardStatePaneTip(), arrowEdge: .bottom)
    }
}

#Preview {
    BoardStatePane(boardState: .init(status: .running, stepsRemaining: 100, stepsSinceReset: 0))
}
