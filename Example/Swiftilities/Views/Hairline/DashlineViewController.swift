//
//  DashlineViewController.swift
//  Swiftilities_Example
//
//  Created by Chad on 12/18/18.
//  Copyright © 2018 Raizlabs. All rights reserved.
//

import UIKit
import Swiftilities

class DashlineViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Dashline example
        let horizontalLine = DashlineView(initialLineStyle: DashlineView.defaultDashedStyle)
        horizontalLine.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(horizontalLine)
        NSLayoutConstraint.activate([
            horizontalLine.widthAnchor.constraint(equalTo: view.widthAnchor),
            horizontalLine.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            horizontalLine.heightAnchor.constraint(equalToConstant: 1.0)
            ])
    }

}
