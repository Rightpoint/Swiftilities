//
//  MainScreenViewController.swift
//  Swiftilities
//
//  Created by Michael Skiba on 11/21/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import UIKit
import Swiftilities

class MainScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showAcknowlegements(_ sender: Any) {
        do {
            let viewModel = try AcknowledgementsViewModel(plistNamed: "Pods-Swiftilities_Example-acknowledgements")
            let veryLightGray = UIColor(hex: 0xEEEEEE, alpha: 1.0)
            let viewController = AcknowledgementsViewController(viewModel: viewModel, licenseViewBackgroundColor: veryLightGray)
            navigationController?.pushViewController(viewController, animated: true)
        }
        catch {
            fatalError("Failed to load acknowledgements")
        }
    }

}
