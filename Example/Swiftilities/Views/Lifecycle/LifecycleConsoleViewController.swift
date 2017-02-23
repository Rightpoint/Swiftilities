//
//  LifecycleConsoleViewController.swift
//  Swiftilities
//
//  Created by Michael Skiba on 2/23/17.
//  Copyright © 2017 Raizlabs. All rights reserved.
//

import UIKit

protocol LifecycleLogDelegate: class {

    func logEvent(description: String)

}

class LifecycleConsoleViewController: UIViewController {

    @IBOutlet weak var lifecycleLogTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func presentLifecycleController(_ sender: Any) {
        let demoViewController = LifecycleDemoViewController()
        demoViewController.lifecycleDelegate = self
        let navigationViewController = UINavigationController(rootViewController: demoViewController)
        present(navigationViewController, animated: true, completion: nil)
    }

}

extension LifecycleConsoleViewController: LifecycleLogDelegate {

    func logEvent(description: String) {
        let currentText = lifecycleLogTextView.text ?? ""
        lifecycleLogTextView.text = "\(currentText)\n\(description)"
    }

}
