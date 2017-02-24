//
//  TextFormattingViewController.swift
//  Swiftilities
//
//  Created by Nicholas Bonatsakis on 02/05/2016.
//  Copyright (c) 2016 Nicholas Bonatsakis. All rights reserved.
//

import UIKit
import Swiftilities

class TextFormattingViewController: UIViewController {

    @IBOutlet var allCapsTextField: FormattedTextField!
    @IBOutlet var onlyNumbersTextField: FormattedTextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        allCapsTextField.formatter = { string in
            return string?.uppercased()
        }

        let nonNumeric = NSCharacterSet.decimalDigits.inverted

        onlyNumbersTextField.formatter = { string in
            return string?.components(separatedBy: nonNumeric).joined(separator: "")
        }
    }

}
