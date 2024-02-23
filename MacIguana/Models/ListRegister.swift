//
//  ListRegister.swift
//  MacIguana
//
//  Created by James on 22/02/2024.
//

import Foundation

/// A struct for displaying registers in lists
struct ListRegister: Identifiable {
    var id: String {
        name
    }
    
    /// A human readable name for the register, such as R0
    let name: String
    
    /// The value that the register holds
    let value: UInt32
    
    /// A string representation of the register
    var string: String {
        var mutableValue = value
        let valueData = Data(bytes: &mutableValue, count: 4)
        
        return String(decoding: valueData, as: UTF8.self)
    }
    
    init(name: String, value: UInt32) {
        self.name = name
        self.value = value
    }
}
