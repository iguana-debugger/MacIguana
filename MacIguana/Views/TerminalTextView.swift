//
//  TerminalTextView.swift
//  MacIguana
//
//  Created by James on 05/04/2024.
//

import SwiftUI

struct TerminalTextView: NSViewRepresentable {
    public let text: String
    
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
//            let documentLength = textView.textStorage?.length ?? 0
            
//            If the location isn't at the end of the document, don't allow the input. This also stops stuff like
//            selecting text to overwrite the document.
//            if affectedCharRange.location != documentLength {
//                return false
//            }
            
            let deleteLength = if replacementString?.isEmpty ?? true {
                affectedCharRange.length
            } else { 0 }
            
            if let convertedData = replacementString?.data(using: .utf8)?.map({ $0.jimulator }) {
                onSend(convertedData)
                
//                Create backspaces for delete events, and send them. If the user is backspacing, convertedData will be
//                empty.
                let deletes = Array(repeating: UInt8(8), count: deleteLength)
                onSend(deletes)
                
//                I'm 99% sure we can't get here with replacementString being nil, but better safe than sorry
                if let replacementString {
//                    We manually speak out text input because we're being sneaky and going around macOS's back, so it
//                    doesn't speak out text itself
                    var attributedConvertedData = AttributedString(replacementString)
                    attributedConvertedData.accessibilitySpeechSpellsOutCharacters = true
                    
                    AccessibilityNotification.Announcement(attributedConvertedData).post()
                }
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
        
        textView.setAccessibilityLabel("Terminal")
        
        return scrollView
    }
    
    func updateNSView(_ nsView: NSScrollView, context: Context) {
        guard let textView = nsView.documentView as? NSTextView else { return }

//        if !terminal.isEmpty {
//            if let terminalString = String(data: Data(terminal), encoding: .utf8) {
//                for char in terminalString {
//                    if let ascii = char.asciiValue {
//                        if ascii == 8 {
//                            let _ = textView.string.popLast()
//                        } else {
//                            textView.string.append(char)
//                        }
//                    }
//                }
//            }
//            
//            terminal.removeAll()
        
        textView.string = text
            
//        TODO: let the user disable this/disable on scroll up
        textView.scrollToEndOfDocument(nil)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onSend: onSend)
    }
}
