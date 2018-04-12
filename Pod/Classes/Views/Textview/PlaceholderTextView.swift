//
//  PlaceholderTextView.swift
//  Swiftilities
//
//  Created by Derek Ostrander on 6/8/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import UIKit

open class PlaceholderTextView: UITextView, PlaceholderConfigurable {

    let placeholderLabel: UILabel = {
        let placeholderLabel = UILabel()
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.textColor = .lightGray
        placeholderLabel.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        return placeholderLabel
    }()

    open var placeholder: String? = nil {
        didSet {
            placeholderLabel.text = placeholder
        }
    }

    open var attributedPlaceholder: NSAttributedString? = nil {
        didSet {
            placeholderLabel.attributedText = attributedPlaceholder
        }
    }

    open var placeholderTextColor: UIColor? = .lightGray {
        didSet {
            placeholderLabel.textColor = placeholderTextColor
        }
    }

    override open var textContainerInset: UIEdgeInsets {
        didSet {
            adjustPlaceholder()
        }
    }

    override open var text: String! {
        didSet {
            adjustPlaceholder()
        }
    }

    override public init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        configureTextView()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureTextView()
    }

    deinit {
        NotificationCenter.default.removeObserver(self,
                                                            name: NSNotification.Name.UITextViewTextDidChange,
                                                            object: nil)
    }

    fileprivate func configureTextView() {
        translatesAutoresizingMaskIntoConstraints = false
        font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        addSubview(placeholderLabel)
        adjustPlaceholder()
        NotificationCenter.default.addObserver(self,
                                                         selector: #selector(textDidChange),
                                                         name:NSNotification.Name.UITextViewTextDidChange,
                                                         object: nil)
    }

    @objc func textDidChange(_ notification: Notification) {
        if let object = notification.object as AnyObject?, object === self {
            adjustPlaceholder()
        }
    }
}
