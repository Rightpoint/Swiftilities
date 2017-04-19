//
//  TintedButtonsViewController.swift
//  Swiftilities
//
//  Created by Michael Skiba on 11/17/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Swiftilities
import UIKit

class TintedButtonsViewController: UIViewController {

    @IBOutlet weak var buttonStack: UIStackView!
    var mutatedButton = TintedButton(fillColor: .red, textColor: .red)

    override func viewDidLoad() {
        super.viewDidLoad()

        let black = UIColor(hex: 0x000000)
        let lightBlue = UIColor(rgba: 0x5555FFFF)
        let newButton = TintedButton(fillColor: black, textColor: lightBlue)
        newButton.setTitle("Button 5", for: .normal)
        mutatedButton.setTitle("Button 6", for: .normal)
        buttonStack.addArrangedSubview(newButton)
        buttonStack.addArrangedSubview(mutatedButton)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mutatedButton.buttonBorderWidth = 3
        mutatedButton.buttonCornerRadius = 6
        mutatedButton.fillColor = .lightGray
        mutatedButton.textColor = .darkText
    }

}
