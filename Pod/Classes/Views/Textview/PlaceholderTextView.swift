//
//  PlaceholderTextView.swift
//  Pods
//
//  Created by Derek Ostrander on 6/8/16.
//
//

import UIKit


public class PlaceholderTextView: UITextView, PlaceholderConfigurable {

    let placeholderLabel: UILabel = {
        let placeholderLabel = UILabel()
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.textColor = .lightGrayColor()
        placeholderLabel.font = UIFont.systemFontOfSize(UIFont.systemFontSize())
        return placeholderLabel
    }()

    public var placeholder: String? = nil {
        didSet {
            placeholderLabel.text = placeholder
        }
    }

    public var attributedPlaceholder: NSAttributedString? = nil {
        didSet {
            placeholderLabel.attributedText = attributedPlaceholder
        }
    }

    public var placeholderTextColor: UIColor? = .lightGrayColor() {
        didSet {
            placeholderLabel.textColor = placeholderTextColor
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
        NSNotificationCenter.defaultCenter().removeObserver(self,
                                                            name: UITextViewTextDidChangeNotification,
                                                            object: nil)
    }

    private func configureTextView() {
        translatesAutoresizingMaskIntoConstraints = false
        font = UIFont.systemFontOfSize(UIFont.systemFontSize())
        addSubview(placeholderLabel)
        adjustPlaceholder()
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(textDidChange),
                                                         name:UITextViewTextDidChangeNotification,
                                                         object: nil)
    }

    func textDidChange(notification: NSNotification) {
        if notification.object === self {
            adjustPlaceholder()
        }
    }
}
