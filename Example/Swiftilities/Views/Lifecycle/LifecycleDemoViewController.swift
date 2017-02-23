//
//  LifecycleDemoViewController.swift
//  Swiftilities
//
//  Created by Michael Skiba on 2/23/17.
//  Copyright © 2017 Raizlabs. All rights reserved.
//

import UIKit

class LifecycleDemoViewController: UIViewController {

    weak var lifecycleDelegate: LifecycleLogDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        addBehaviors([LogViewEventsBehavior()])
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissSelf(sender:)))
    }

    func dismissSelf(sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

}
