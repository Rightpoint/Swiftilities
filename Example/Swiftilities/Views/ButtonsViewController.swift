//
//  ButtonsViewController.swift
//  Swiftilities
//
//  Created by Nicholas Bonatsakis on 5/15/17.
//  Copyright © 2017 Raizlabs. All rights reserved.
//

import Swiftilities
import UIKit

class ButtonsViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .darkGray

        let rectButton = BetterButton(shape: .rectangle(cornerRadius: 10), style: .solid(backgroundColor: .purple, foregroundColor: .white))
        rectButton.setTitle("Rectangle (Solid)", for: .normal)
        stackView.addArrangedSubview(rectButton)
        rectButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
        rectButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        rectButton.addTarget(self, action: #selector(toggleLoading), for: .touchUpInside)

        let pillOutline = BetterButton(shape: .pill, style: .outlineOnly(backgroundColor: .clear, foregroundColor: .black))
        pillOutline.setTitle("Pill (Outline-Only)", for: .normal)
        stackView.addArrangedSubview(pillOutline)
        pillOutline.widthAnchor.constraint(equalToConstant: 300).isActive = true
        pillOutline.heightAnchor.constraint(equalToConstant: 44).isActive = true

        let pillOutlineInvert = BetterButton(shape: .pill, style: .outlineInvert(backgroundColor: .darkGray, foregroundColor: .green))
        pillOutlineInvert.setTitle("Pill (Outline-Invert)", for: .normal)
        stackView.addArrangedSubview(pillOutlineInvert)
        pillOutlineInvert.widthAnchor.constraint(equalToConstant: 300).isActive = true
        pillOutlineInvert.heightAnchor.constraint(equalToConstant: 44).isActive = true
        pillOutlineInvert.addTarget(self, action: #selector(toggleLoading), for: .touchUpInside)

        let getButton = BetterButton(shape: .rectangle(cornerRadius: 0), style: .outlineInvert(backgroundColor: .darkGray, foregroundColor: .blue))
        getButton.setTitle("GET", for: .normal)
        getButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        getButton.setContentCompressionResistancePriority(UILayoutPriority.required, for: .horizontal)
        getButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        stackView.addArrangedSubview(getButton)
        
        let baselineStyle = BetterButton.StyleAttributes(backgroundColor: .white, foregroundColor: .blue, borderColor: .blue, borderWidth: 2.0)
        let adjustMode = BetterButton.Style.HighlightAdjustMode.darken(by: nil)
        let disabledStateAttributes = BetterButton.StyleAttributes(backgroundColor: .white, foregroundColor: .gray, borderColor: nil, borderWidth: nil)
        let disabledState = BetterButton.StateStyle(controlState: .disabled, attributes: disabledStateAttributes)
        let highlightStyle = BetterButton.StyleAttributes(backgroundColor: .blue, foregroundColor: .white, borderColor: .white, borderWidth: 1.0)
        let highlightedState = BetterButton.StateStyle(controlState: .highlighted, attributes: highlightStyle)
        let customStyle = BetterButton.Style.custom(normal: baselineStyle, customStateStyles: [disabledState, highlightedState], adjustMode: adjustMode)
        
        let customStatePill = BetterButton(shape: .pill, style: customStyle)
        customStatePill.setTitle("Pill (Custom) Disable Me!", for: .normal)
        customStatePill.setTitle("I'm Higlighted", for: .highlighted)
        customStatePill.setTitle("I'm Selected", for: .selected)
        customStatePill.setTitle("I'm Disabled", for: .disabled)
        customStatePill.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        customStatePill.setContentCompressionResistancePriority(UILayoutPriority.required, for: .horizontal)
        customStatePill.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        customStatePill.widthAnchor.constraint(equalToConstant: 300).isActive = true
        customStatePill.heightAnchor.constraint(equalToConstant: 44).isActive = true
        customStatePill.addTarget(self, action: #selector(flipEnabled(button:)), for: .primaryActionTriggered)
        stackView.addArrangedSubview(customStatePill)

        let circleOutlineInvert = BetterButton(shape: .circle, style: .outlineInvert(backgroundColor: .darkGray, foregroundColor: .red))
        circleOutlineInvert.iconImage = #imageLiteral(resourceName: "icn-twitter")
        stackView.addArrangedSubview(circleOutlineInvert)
        circleOutlineInvert.widthAnchor.constraint(equalToConstant: 74).isActive = true
        circleOutlineInvert.heightAnchor.constraint(equalToConstant: 74).isActive = true
        circleOutlineInvert.addTarget(self, action: #selector(toggleLoading), for: .touchUpInside)

        let rectOutline = BetterButton(shape: .rectangle(cornerRadius: 4), style: .outlineOnly(backgroundColor: .clear, foregroundColor: .white))
        rectOutline.setTitle("Rect Outline Only", for: .normal)
        stackView.addArrangedSubview(rectOutline)
        rectOutline.widthAnchor.constraint(equalToConstant: 300).isActive = true
        rectOutline.heightAnchor.constraint(equalToConstant: 44).isActive = true

    }

    @objc func toggleLoading(button: BetterButton) {
        button.isLoading = true
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            button.isLoading = false
        }
    }
    
    @objc func flipEnabled(button: BetterButton) {
        button.isEnabled = !button.isEnabled
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            button.isEnabled = !button.isEnabled
        }
    }
}
