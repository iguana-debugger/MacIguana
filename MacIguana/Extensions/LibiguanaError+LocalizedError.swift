//
//  LibiguanaError+LocalizedError.swift
//  MacIguana
//
//  Created by James on 30/03/2024.
//

import Foundation
import Libiguana

extension LibiguanaError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .NoStdin(message: let message):
            message
        case .NoStdout(message: let message):
            message
        case .Io(message: let message):
            message
        case .Utf8Error(message: let message):
            message
        case .ParseError(message: let message):
            message
        case .IntegerOverflow(message: let message):
            message
        case .TryFromSliceError(message: let message):
            message
        case .InvalidStatus(message: let message):
            message
        case .InvalidRegisterBufferLength(message: let message):
            message
        case .AasmDoesNotExist(message: let message):
            message
        case .FromUtf8Error(message: let message):
            message
        case .MnemonicsDoesNotExist(message: let message):
            message
        case .TooManyTraps(message: let message):
            message
        }
    }
}
