//
//  GradientViewController.swift
//  Swiftilities
//
//  Created by Nicholas Bonatsakis on 5/1/17.
//  Copyright © 2017 Raizlabs. All rights reserved.
//

import UIKit
import Swiftilities

class GradientViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let gradients = [
            GradientView(direction: .leftToRight, colors: [.red, .white, .blue]),
            GradientView(direction: .topToBottom, colors: [.green, .black, .orange]),
            GradientView(
                direction: .custom(start: CGPoint(x: 0, y: 0), end: CGPoint(x: 1, y: 1)),
                colors: [.blue, .orange, .purple]
            ),
            GradientView(direction: .topToBottom, colors: [.purple, .black], locations: [0.9, 1.0])
        ]

        gradients.forEach { view in
            stackView.addArrangedSubview(view)

            view.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
            view.heightAnchor.constraint(equalToConstant: 64.0).isActive = true

            view.layer.masksToBounds = true
            view.layer.cornerRadius = 6.0
        }
    }

}
