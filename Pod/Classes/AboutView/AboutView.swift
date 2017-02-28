//
//  AboutView.swift
//  Swiftilities
//
//  Created by Michael Skiba on 2/28/17.
//  Copyright © 2017 Raizlabs. All rights reserved.
//

import UIKit

open class AboutView: UIView {

    open let imageView: UIImageView
    open let label: UILabel

    private var internalConstraints: [NSLayoutConstraint] = []

    /// Creates a UIView with an image view displaying the supplied image, and a label with version info beneath it
    ///
    /// This view implements autolayout, to find the correct height for the view, use `systemLayoutSizeFittingSize`
    ///
    /// - Parameters:
    ///   - image: The image to display
    ///   - frame: The initial frame of the view
    public init(image: UIImage, frame: CGRect = CGRect()) {
        self.imageView = UIImageView(image: image)
        label = UILabel()
        super.init(frame: frame)
        prepareView()
    }

    @available(*, unavailable) required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    /// Overriden to make sure that the layout guides are in place before the constraints are set up
    open override func updateConstraints() {
        super.updateConstraints()
        guard internalConstraints.isEmpty else {
            return
        }
        internalConstraints = [
            imageView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            layoutMarginsGuide.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            layoutMarginsGuide.trailingAnchor.constraint(equalTo: label.trailingAnchor),
            layoutMarginsGuide.bottomAnchor.constraint(equalTo: label.bottomAnchor),
        ]
        NSLayoutConstraint.activate(internalConstraints)
    }

}

private extension AboutView {

    func prepareView() {
        layoutMargins = UIEdgeInsets(top: 31, left: 0, bottom: 31, right: 0)

        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        label.backgroundColor = .clear
        label.textAlignment = .center
        label.textColor = UIColor(red: 0.5, green: 0.5, blue: 0.51, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "\(AppInfo.version) (\(AppInfo.buildNumber))"
        label.translatesAutoresizingMaskIntoConstraints = false

        addSubview(imageView)
        addSubview(label)
    }

}
