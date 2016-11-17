//
//  TintedButtonsViewController.swift
//  Swiftilities
//
//  Created by Michael Skiba on 11/17/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import UIKit
import Swiftilities

class TintedButtonsViewController: UIViewController {

    @IBOutlet weak var buttonStack: UIStackView!
    var mutatedButton = TintedButton(backgroundColor: .red, tintColor: .red)

    override func viewDidLoad() {
        super.viewDidLoad()

        let newButton = TintedButton(backgroundColor: .black, tintColor: .lightGray)
        newButton.setTitle("Button 5", for: .normal)
        mutatedButton.setTitle("Button 6", for: .normal)
        buttonStack.addArrangedSubview(newButton)
        buttonStack.addArrangedSubview(mutatedButton)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mutatedButton.rz_borderThickness = 3
        mutatedButton.rz_cornerRadius = 6
        mutatedButton.rz_backgroundColor = .lightGray
        mutatedButton.rz_tintColor = .darkText
    }

}
