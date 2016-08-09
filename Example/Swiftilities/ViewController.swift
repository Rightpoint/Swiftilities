//
//  ViewController.swift
//  Swiftilities
//
//  Created by Nicholas Bonatsakis on 02/05/2016.
//  Copyright (c) 2016 Nicholas Bonatsakis. All rights reserved.
//

import UIKit
import Swiftilities

class ViewController: UIViewController {

    @IBOutlet var allCapsTextField: FormattedTextField!
    @IBOutlet var onlyNumbersTextField: FormattedTextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Logger

        Log.logLevel = .Error
        Log.error("Test log")

        allCapsTextField.formatter = { string in
            return string?.uppercaseString
        }

        let nonNumeric = NSCharacterSet.decimalDigitCharacterSet().invertedSet

        onlyNumbersTextField.formatter = { string in
            return string?.componentsSeparatedByCharactersInSet(nonNumeric).joinWithSeparator("")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

