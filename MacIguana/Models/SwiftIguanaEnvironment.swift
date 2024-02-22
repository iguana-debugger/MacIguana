//
//  SwiftIguanaEnvironment.swift
//  MacIguana
//
//  Created by James on 21/02/2024.
//

import Foundation
import Libiguana

/// A wrapper around `IguanaEnvironment` to allow for Observable
@Observable
class SwiftIguanaEnvironment {
    let environment: IguanaEnvironment
    
    init() throws {
        do {
            environment = try IguanaEnvironment()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
