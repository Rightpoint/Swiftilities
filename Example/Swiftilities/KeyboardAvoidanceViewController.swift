//
//  KeyboardAvoidanceViewController.swift
//  Swiftilities
//
//  Created by Michael Skiba on 11/11/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import Swiftilities

class KeyboardAvoidanceViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self

        view.addKeyboardLayoutGuide().topAnchor.constraint(greaterThanOrEqualTo: textField.bottomAnchor, constant: 10).isActive = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }

}

extension KeyboardAvoidanceViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
