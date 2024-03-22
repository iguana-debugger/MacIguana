//
//  KomodoDocument.swift
//  MacIguana
//
//  Created by James on 15/03/2024.
//

import Foundation
import Libiguana
import SwiftUI
import UniformTypeIdentifiers

enum KomodoDocumentError: Error {
    case AsmFileDecodeFailed
}

struct KomodoDocument: FileDocument {
    static var readableContentTypes: [UTType] = [.assemblyLanguageSource]
    
    init(configuration: ReadConfiguration) throws {
//        We don't actually need to care about opening the file here - we just need the URL, which is given in
//        DocumentGroup
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        throw CocoaError(.fileWriteNoPermission)
    }
}
