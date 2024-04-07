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
    
    /// The buffer to feed into the terminal. When read in, the terminal will empty this buffer. The terminal handles
    /// conversion from Jimulator to terminal bytes.
    @Binding var terminal: [UInt8]
    
    /// A callback that passes up the terminal's `send` output. Pre-formatted to be Komodo-compatible.
    public let onSend: (_ data: [UInt8]) -> ()
    
    class Coordinator: NSObject, TerminalViewDelegate {
        /// A callback that passes up the terminal's `send` output. Pre-formatted to be Komodo-compatible.
        public let onSend: (_ data: [UInt8]) -> ()
        
        public init(onSend: @escaping (_: [UInt8]) -> Void) {
            self.onSend = onSend
        }
        
        func sizeChanged(source: SwiftTerm.TerminalView, newCols: Int, newRows: Int) {}
        
        func setTerminalTitle(source: SwiftTerm.TerminalView, title: String) {}
        
        func hostCurrentDirectoryUpdate(source: SwiftTerm.TerminalView, directory: String?) {}
        
        func send(source: SwiftTerm.TerminalView, data: ArraySlice<UInt8>) {
//            Jimulator expects some different keycodes to what the terminal gives, so we convert them here
            let convertedData: [UInt8] = data.map { $0.jimulator }
            onSend(convertedData)
        }
        
        func scrolled(source: SwiftTerm.TerminalView, position: Double) {
            print(position)
        }
        
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
        
//        todo: https://migueldeicaza.github.io/SwiftTermDocs/documentation/swiftterm/terminalview/backspacesendscontrolh
//        https://migueldeicaza.github.io/SwiftTermDocs/documentation/swiftterm/terminalview/returnbytesequence may help with returns?
        
        terminalView.terminalDelegate = context.coordinator
        terminalView.configureNativeColors()
        
        return terminalView
    }
    
    func updateNSView(_ nsView: SwiftTerm.TerminalView, context: Context) {
        if !terminal.isEmpty {
            for char in terminal {
                let xpos = nsView.terminal.getCursorLocation().x
                let convertedChar = char.terminal(xpos)
                
                nsView.feed(byteArray: ArraySlice(convertedChar))
            }
            
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
