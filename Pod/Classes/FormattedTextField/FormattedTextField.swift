//
//  FormattedTextField.swift
//  Pods
//
//  Created by Rob Visentin on 8/9/16.
//  Copyright (c) 2016 Raizlabs. All rights reserved.
//

import UIKit

class FormattedTextField: UITextField {

    typealias Formatter = String? -> String?

    var formatter: Formatter? {
        didSet {
            if let formatter = formatter {
                super.text = formatter(text)
            }
        }
    }

    override var text: String? {
        didSet {
            if let formatter = formatter {
                super.text = formatter(text)
            }
        }
    }

    private var savedLength = 0
    private var savedSelectedRange: UITextRange?

    convenience init(formatter: Formatter? = nil) {
        self.init(frame: .zero)

        self.formatter = formatter

        addTarget(self, action: #selector(textChanged), forControlEvents: .EditingChanged)
    }

}

// MARK: - Private

private extension FormattedTextField {

    func saveSelectionState() {
        savedLength = text?.characters.count ?? 0
        savedSelectedRange = selectedTextRange
    }

    func restoreSelectedState() {
        if let savedRange = savedSelectedRange, text = text {
            let newLen = text.characters.count
            let diff = max(0, newLen - savedLength)

            if let start = positionFromPosition(savedRange.start, offset: diff), end = positionFromPosition(savedRange.end, offset: diff) {
                selectedTextRange = textRangeFromPosition(start, toPosition: end)
            }

            savedLength = 0
            savedSelectedRange = nil
        }
    }

    @objc func textChanged() {
        if let formatter = formatter {
            saveSelectionState()
            super.text = formatter(text)
            restoreSelectedState()
        }
    }
    
}
