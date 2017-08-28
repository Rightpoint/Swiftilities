//
//  UIControlBlocksViewController.swift
//  Swiftilities
//
//  Created by Brian King on 8/25/17.
//  Copyright © 2017 Raizlabs. All rights reserved.
//

import UIKit
import Swiftilities

class UIControlBlocksViewController: UIViewController {

    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var button: UIButton!
    @IBOutlet var slider: UISlider!
    @IBOutlet var stepper: UIStepper!
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var textField: UITextField!

    func report(status: String) {
        statusLabel.text = status
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        button.setCallback(for: .touchUpInside) { [weak self] _ in
            self?.report(status: "Button Tapped")
        }
        slider.setCallback(for: .valueChanged) { [weak self] (slider) in
            self?.report(status: "Slider: \(slider.value)")
        }
        stepper.setCallback(for: .valueChanged) { [weak self] (stepper) in
            self?.report(status: "Stepper: \(stepper.value)")
        }
        segmentedControl.setCallback(for: .valueChanged) { [weak self] (segmentedControl) in
            self?.report(status: "Segment: \(segmentedControl.selectedSegmentIndex)")
        }
        textField.setCallback(for: .editingChanged) { [weak self] (textField) in
            self?.report(status: "TextField: \(textField.text ?? "")")
        }
    }
}
