//
//  FormattedTextField.swift
//  Swiftilities
//
//  Created by Rob Visentin on 8/9/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import UIKit

open class FormattedTextField: UITextField {

    public typealias Formatter = (String?) -> String?

    /*
     An optional formatter that transforms any text values set set for the text field into the new value
     Because this is a closure, it cannot be encoded with NSCoding and must be restored manually if
     state restoration is used.
    */
    public var formatter: Formatter? {
        didSet {
            removeTarget(self, action: #selector(textChanged), for: .editingChanged)
            if let formatter = formatter {
                super.text = formatter(text)
                addTarget(self, action: #selector(textChanged), for: .editingChanged)
            }
        }
    }

    open override var text: String? {
        didSet {
            if let formatter = formatter {
                super.text = formatter(text)
            }
        }
    }

    /**
     A convenience initializer that allows setting the formatter on init()

     - parameter formatter: The string tranfromation to apply to the text set for this control.
     - parameter frame:     The frame of the view, default value is CGRect.zero
     */
    public convenience init(formatter: Formatter?, frame: CGRect = .zero) {
        self.init(frame: frame)
        self.formatter = formatter
        if formatter != nil {
            addTarget(self, action: #selector(textChanged), for: .editingChanged)
        }
    }

}

// MARK: - Private

private extension FormattedTextField {

    typealias TextFieldState = (length: Int, selectedRange: UITextRange?)

    func saveTextFieldState() -> TextFieldState {
        let savedLength = text?.count ?? 0
        return (length: savedLength, selectedRange: selectedTextRange)
    }

    func restoreTextField(to state: TextFieldState) {
        if let savedRange = state.selectedRange, let text = text {
            let newLen = text.count
            let diff = max(0, newLen - state.length)

            if let start = position(from: savedRange.start, offset: diff),
                let end = position(from: savedRange.end, offset: diff) {
                selectedTextRange = textRange(from: start, to: end)
            }
        }
    }

    @objc func textChanged() {
        if let formatter = formatter {
            let oldState = saveTextFieldState()
            super.text = formatter(text)
            restoreTextField(to: oldState)
        }
    }

}
