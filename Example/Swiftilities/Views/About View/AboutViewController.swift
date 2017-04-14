//
//  AboutViewController.swift
//  Swiftilities
//
//  Created by Michael Skiba on 2/28/17.
//  Copyright © 2017 Raizlabs. All rights reserved.
//

import Swiftilities
import UIKit

class AboutViewController: UIViewController, FeedbackPresenter {

    @IBOutlet weak var actionStack: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let aboutView = AboutView(image: #imageLiteral(resourceName: "logo-built-by-RZ"), imageAccessibilityLabel: "Designed and developed by Raizlabs")
        actionStack.addArrangedSubview(aboutView)
    }

    @IBAction func showMailComposer(_ sender: UIView) {
        presentSendFeedback(to: "feedback@raizlabs.com") { _ in
            Log.info("Email done")
        }
    }

    @IBAction func showShareApp(_ sender: UIView) {
        guard let url = URL(string: "http://raizlabs.com") else {
            return
        }
        presentShareApp(shareText: "Share App", shareURL: url, presentedFrom: sender)
    }
}
