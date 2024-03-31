//
//  JimulatorTerminalAdapter.swift
//  MacIguana
//
//  Created by James on 29/03/2024.
//

import SwiftUI
import SwiftTerm

struct JimulatorTerminalAdapter: NSViewRepresentable {
    typealias NSViewType = TerminalView
    
    @Binding var terminal: [UInt8]
    
    public let onSend: (_ data: ArraySlice<UInt8>) -> ()
    
    class Coordinator: NSObject, TerminalViewDelegate {
        public let onSend: (_ data: ArraySlice<UInt8>) -> ()
        
        public init(onSend: @escaping (_: ArraySlice<UInt8>) -> Void) {
            self.onSend = onSend
        }
        
        func sizeChanged(source: SwiftTerm.TerminalView, newCols: Int, newRows: Int) {}
        
        func setTerminalTitle(source: SwiftTerm.TerminalView, title: String) {}
        
        func hostCurrentDirectoryUpdate(source: SwiftTerm.TerminalView, directory: String?) {}
        
        func send(source: SwiftTerm.TerminalView, data: ArraySlice<UInt8>) {
            print("\(data)")
            onSend(data)
        }
        
        func scrolled(source: SwiftTerm.TerminalView, position: Double) {}
        
        func clipboardCopy(source: SwiftTerm.TerminalView, content: Data) {}
        
        func rangeChanged(source: SwiftTerm.TerminalView, startY: Int, endY: Int) {}
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(onSend: onSend)
    }
    
    func makeNSView(context: Context) -> SwiftTerm.TerminalView {
        let terminalView = TerminalView()
        
        var terminalOptions = TerminalOptions.default
        terminalOptions.convertEol = true
        let terminal = Terminal(delegate: terminalView, options: terminalOptions)
        terminalView.terminal = terminal
        
        terminalView.terminalDelegate = context.coordinator
        
        terminalView.configureNativeColors()
        
        return terminalView
    }
    
    func updateNSView(_ nsView: SwiftTerm.TerminalView, context: Context) {
        if !terminal.isEmpty {
            nsView.feed(byteArray: ArraySlice(terminal))
            terminal.removeAll()
        }
    }
}

//import SwiftUI
//
//struct EndOfTextEditor: NSViewRepresentable {
//    @Binding var text: String
//    
//    func makeNSView(context: Context) -> NSTextView {
//        let textView = NSTextView()
//        textView.isEditable = true
//        textView.isRichText = false
//        textView.delegate = context.coordinator
//        return textView
//    }
//    
//    func updateNSView(_ nsView: NSTextView, context: Context) {
//        nsView.string = text
//        if text.isEmpty {
//            nsView.becomeFirstResponder()
//        } else {
//            nsView.moveToEndOfDocument(nil)
//        }
//    }
//    
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//    
//    class Coordinator: NSObject, NSTextViewDelegate {
//        var parent: EndOfTextEditor
//        
//        init(_ parent: EndOfTextEditor) {
//            self.parent = parent
//        }
//        
//        func textDidChange(_ notification: Notification) {
//            guard let textView = notification.object as? NSTextView else { return }
//            textView.moveToEndOfDocument(nil)
//        }
//        
//        func textDidBeginEditing(_ notification: Notification) {
//            guard let textView = notification.object as? NSTextView else { return }
//            textView.moveToEndOfDocument(nil)
//        }
//    }
//}
