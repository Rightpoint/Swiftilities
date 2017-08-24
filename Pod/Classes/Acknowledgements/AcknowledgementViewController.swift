//
//  AcknowledgementViewController.swift
//  Swiftilities
//
//  Created by Michael Skiba on 11/21/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import UIKit

open class AcknowledgementViewController: UIViewController {

    public static let defaultLicenseFormatter: (String) -> NSAttributedString = { string in
        let font = UIFont.preferredFont(forTextStyle: .body)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.hyphenationFactor = 1
        paragraphStyle.paragraphSpacing = font.pointSize / 2
        let attributes: [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.font: font,
            NSAttributedStringKey.paragraphStyle: paragraphStyle,
            ]
        return NSAttributedString(string: string, attributes: attributes)
    }

    public var viewModel = AcknowledgementViewModel(title: "", license: "") {
        didSet {
            updateWithViewModel()
        }
    }

    public var scrollView: UIScrollView! {
        return view as? UIScrollView
    }

    public var licenseFormatter: (String) -> NSAttributedString = defaultLicenseFormatter

    public let labelView: UILabel = {
        let labelView = UILabel()
        labelView.numberOfLines = 0
        return labelView
    }()

    public required init(viewModel: AcknowledgementViewModel, licenseFormatter: @escaping (String) -> NSAttributedString, viewBackgroundColor: UIColor?) {
        super.init(nibName: nil, bundle: nil)
        self.licenseFormatter = licenseFormatter
        self.viewModel = viewModel
        if let backgroundColor = viewBackgroundColor {
            view.backgroundColor = backgroundColor
        }
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func loadView() {
        let scrollView = VerticalScrollView()
        scrollView.alwaysBounceVertical = true
        view = scrollView
        view.backgroundColor = .white
        view.addSubview(labelView)
        configureLayout()
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        updateWithViewModel()
    }

}

private extension AcknowledgementViewController {

    enum LayoutConstants {
        static let defaultInset = UIEdgeInsets(top: 14, left: 14, bottom: 14, right: 14)
    }

    func configureLayout() {
        scrollView.contentInset = LayoutConstants.defaultInset
        labelView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelView.topAnchor.constraint(equalTo: view.topAnchor),
            labelView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            labelView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            labelView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ])
    }

    func updateWithViewModel() {
        navigationItem.title = viewModel.title
        labelView.attributedText = licenseFormatter(viewModel.license)
    }
}

private class VerticalScrollView: UIScrollView {

    private var subviewWidthConstraints: [NSLayoutConstraint] = []

    override var contentInset: UIEdgeInsets {
        didSet {
            updateContentInset()
        }
    }

    override func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)
        updateContentInset()
    }

    func updateContentInset() {
        NSLayoutConstraint.deactivate(subviewWidthConstraints)
        let newConstraints: [NSLayoutConstraint] = subviews.map { subView in
            let constriant = subView.widthAnchor.constraint(equalTo: widthAnchor,
                                                            constant: -(contentInset.left + contentInset.right))
            constriant.priority = UILayoutPriority.defaultHigh
            return constriant
        }
        subviewWidthConstraints = newConstraints
        NSLayoutConstraint.activate(newConstraints)
    }
}
