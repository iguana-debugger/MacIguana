//
//  LockedTextField.swift
//  MacIguana
//
//  Created by James on 05/04/2024.
//

import SwiftUI

struct LockedTextField: NSViewRepresentable {
    /// The buffer to feed into the terminal. When read in, the terminal will empty this buffer. The terminal handles
    /// conversion from Jimulator to terminal bytes.
    @Binding var terminal: [UInt8]
    
    /// A callback that passes up the terminal's `send` output. Pre-formatted to be Komodo-compatible.
    public let onSend: (_ data: [UInt8]) -> ()
    
    typealias NSViewType = NSScrollView

    class Coordinator: NSObject, NSTextViewDelegate {
        private let onSend: (_ data: [UInt8]) -> ()
        
        init(onSend: @escaping (_: [UInt8]) -> Void) {
            self.onSend = onSend
        }
        
        func textDidChange(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else { return }
            textView.moveToEndOfDocument(nil)
        }
        
        func textDidBeginEditing(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else { return }
            textView.moveToEndOfDocument(nil)
        }
        
        func textView(_ textView: NSTextView, shouldChangeTextIn affectedCharRange: NSRange, replacementString: String?) -> Bool {
//            Check if the replacement string is empty (indicating a deletion)
            if replacementString?.isEmpty ?? true {
                return false
            }
            
            let documentLength = textView.textStorage?.length ?? 0
            
//            If the location isn't at the end of the document, don't allow the input. This also stops stuff like
//            selecting text to overwrite the document.
            if affectedCharRange.location != documentLength {
                return false
            }
            
            if let convertedData = replacementString?.data(using: .utf8)?.map({ $0.jimulator }) {
                onSend(convertedData)
            }
            
            return false
        }
    }
    
    func makeNSView(context: Context) -> NSScrollView {
        let scrollView = NSTextView.scrollableTextView()
        
        guard let textView = scrollView.documentView as? NSTextView else { fatalError("scrollableTextView didn't return an NSTextView?") }

        textView.isEditable = true
        textView.isRichText = false
        textView.allowsUndo = false
        textView.font = .monospacedSystemFont(ofSize: NSFont.systemFontSize, weight: .regular)
        textView.delegate = context.coordinator
        
        return scrollView
    }
    
    func updateNSView(_ nsView: NSScrollView, context: Context) {
        guard let textView = nsView.documentView as? NSTextView else { return }

        if !terminal.isEmpty {
            if let terminalString = String(data: Data(terminal), encoding: .utf8) {
                for char in terminalString {
                    if let ascii = char.asciiValue {
                        if ascii == 8 {
                            let _ = textView.string.popLast()
                        } else {
                            textView.string.append(char)
                        }
                    }
                }
            }
            
            terminal.removeAll()
            
//            TODO: let the user disable this/disable on scroll up
            textView.scrollToEndOfDocument(nil)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onSend: onSend)
    }
}
