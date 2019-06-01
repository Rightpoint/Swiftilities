//
//  AccessibilityViewController.swift
//  Swiftilities_Example
//
//  Created by Paul Uhn on 2/26/19.
//  Copyright © 2019 Raizlabs. All rights reserved.
//

import UIKit
import Swiftilities

class AccessibilityViewController: UIViewController {

    @IBOutlet weak var announceString1: UITextField!
    @IBOutlet weak var announceString2: UITextField!
    @IBOutlet weak var announceDelay1: UITextField!
    @IBOutlet weak var announceDelay2: UITextField!
    @IBOutlet weak var announceConsole: UITextView!
    
    private let accessibility = Accessibility.shared
    private var delay1: Double { return announceDelay1.text.double }
    private var delay2: Double { return announceDelay2.text.double }

    override func viewDidLoad() {
        super.viewDidLoad()

        announceConsole.text = accessibility.isVoiceOverRunning ? "Tap Talk Button" : "Turn on VoiceOver"
    }
    
    @IBAction func talkButtonTapped(_ sender: UIButton) {
        guard accessibility.isVoiceOverRunning else {
            append("Turn on VoiceOver")
            return
        }
        guard let string1 = announceString1.text,
            let string2 = announceString2.text else {
                append("Fill in both text fields")
                return
        }
        announce(string1, delay1)
        announce(string2, delay2)
    }
    
    private func append(_ text: String) {
        announceConsole.text += text + "\n"
    }
    
    private func announce(_ text: String, _ delay: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.accessibility.announce(text) { string, success in
                let s = String(describing: string)
                if success {
                    self.append("Announced '\(s)'")
                } else {
                    self.append("Did not announce '\(s)'")
                }
            }
        }
    }
}

private extension String {
    var double: Double {
        return Double(self) ?? 0
    }
}
private extension Optional where Wrapped == String {
    var double: Double {
        switch self {
        case .some(let value):
            return value.double
        case .none:
            return 0
        }
    }
}
