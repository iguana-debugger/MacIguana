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
    
//    public var environment: SwiftIguanaEnvironment
    public private(set) var includePaths: [String] = []
    
    public private(set) var asmString: String
    
    init(configuration: ReadConfiguration) throws {
//        Here, we note include files so that aasm can find them
        
        guard let asmData = configuration.file.regularFileContents else {
            throw CocoaError(.fileReadCorruptFile)
        }
        
        guard let asmString = String(data: asmData, encoding: .utf8) else {
            throw CocoaError(.fileReadCorruptFile)
        }
        
        self.asmString = asmString
        
        let regex = /(?m)^(?!;).*include +[^; ]+/
        
        for match in asmString.matches(of: regex) {
            if let includePath = match.output.split(separator: /\s+/).last {
                includePaths.append(String(includePath))
            }
        }
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        throw CocoaError(.fileWriteNoPermission)
    }
}
