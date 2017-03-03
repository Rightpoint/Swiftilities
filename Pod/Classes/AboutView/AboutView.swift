//
//  AboutView.swift
//  Swiftilities
//
//  Created by Michael Skiba on 2/28/17.
//  Copyright © 2017 Raizlabs. All rights reserved.
//

import UIKit

open class AboutView: UIView {

    open let imageView: UIImageView = {
        let imageView = UIImageView()

        imageView.accessibilityTraits = UIAccessibilityTraitNone

        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    open let label: UILabel = {
        let label = UILabel()

        label.backgroundColor = .clear
        label.textAlignment = .center
        label.textColor = UIColor(red: 0.5, green: 0.5, blue: 0.51, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "\(AppInfo.version) (\(AppInfo.buildNumber))"
        label.accessibilityLabel = String(format: NSLocalizedString("Version %@ build %@", comment: "Accessibility version of app version and build number label"), AppInfo.accessibleVersion, AppInfo.buildNumber)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private var internalConstraints: [NSLayoutConstraint] = []

    /// Creates a UIView with an image view displaying the supplied image, and a label with version info beneath it
    ///
    /// This view implements autolayout, to find the correct height for the view, use `systemLayoutSizeFittingSize`
    ///
    /// - Parameters:
    ///   - image: The image to display
    ///   - imageAccessibilityLabel: The text equivalent of the image, for users of VoiceOver
    ///                              and other assistive technologies.
    ///   - frame: The initial frame of the view
    public init(image: UIImage, imageAccessibilityLabel: String? = nil, frame: CGRect = CGRect()) {
        super.init(frame: frame)

        imageView.image = image
        imageView.accessibilityLabel = imageAccessibilityLabel
        imageView.isAccessibilityElement = (imageAccessibilityLabel != nil)

        prepareView()
        prepareLayout()
    }

    @available(*, unavailable) required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

private extension AboutView {

    func prepareView() {
        addSubview(imageView)
        addSubview(label)
    }

    func prepareLayout() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 31),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            trailingAnchor.constraint(equalTo: label.trailingAnchor),
            bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: 31),
            ])
    }

}
