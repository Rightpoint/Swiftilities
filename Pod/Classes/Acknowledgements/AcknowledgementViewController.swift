//
//  AcknowledgementViewController.swift
//  Pods
//
//  Created by Michael Skiba on 11/21/16.
//
//

import UIKit

open class AcknowledgementViewController: UIViewController {

    public static let defaultLicenseFormatter: (String) -> NSAttributedString
        = { string in
            let font = UIFont.preferredFont(forTextStyle: .body)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.hyphenationFactor = 1
            paragraphStyle.paragraphSpacing = font.pointSize / 2
            let attributes: [String:Any] = [NSFontAttributeName: font,
                                            NSParagraphStyleAttributeName: paragraphStyle]
            return NSAttributedString(string: string, attributes: attributes)
    }

    public var viewModel = AcknowledgementViewModel(title: "", license: "") {
        didSet {
            updateWithViewModel()
        }
    }

    public var licenseFormatter: (String) -> NSAttributedString = defaultLicenseFormatter

    public let textView: UITextView = {

        let textView = UITextView()
        textView.isEditable = false
        textView.alwaysBounceVertical = true

        return textView
    }()

    convenience init(viewModel: AcknowledgementViewModel, licenseFormatter: @escaping (String) -> NSAttributedString) {
        self.init()
        self.licenseFormatter = licenseFormatter
        self.viewModel = viewModel
    }

    open override func loadView() {
        view = UIView()
        view.addSubview(textView)
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        updateWithViewModel()
        configureLayout()
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }

    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        textView.setContentOffset(CGPoint(x: 0, y: -topLayoutGuide.length), animated: false)
    }
}

private extension AcknowledgementViewController {

    func configureLayout() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.topAnchor),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ])
    }

    func updateWithViewModel() {
        navigationItem.title = viewModel.title
        textView.attributedText = licenseFormatter(viewModel.license)
    }
}
