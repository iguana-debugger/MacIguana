//
//  KmdparseLine+Identifiable.swift
//  MacIguana
//
//  Created by James on 11/03/2024.
//

import Foundation
import Libiguana

extension KmdparseLine: Identifiable {
    public var id: Int {
        self.hashValue
    }
}
