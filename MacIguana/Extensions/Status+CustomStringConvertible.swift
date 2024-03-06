//
//  Status+String.swift
//  MacIguana
//
//  Created by James on 05/03/2024.
//

import Foundation
import Libiguana

extension Status: CustomStringConvertible {
    public var description: String {
        switch self {
        case .normal:
            "Normal"
        case .busy:
            "Busy"
        case .stopped:
            "Stopped"
        case .breakpoint:
            "Breakpoint"
        case .memfault:
            "Memfault"
        case .finished:
            "Finished"
        case .running:
            "Running"
        case .runningSwi:
            "Running SWI"
        case .stepping:
            "Stepping"
        case .broken:
            "Broken!"
        }
    }
}
