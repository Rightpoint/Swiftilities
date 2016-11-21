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
            let viewModel = try AcknowledgementsViewModel(pListNamed: "Pods-Swiftilities_Example-acknowledgements")
            let viewController = AcknowledgementsViewController(viewModel: viewModel)
            navigationController?.pushViewController(viewController, animated: true)
        }
        catch {
            fatalError("Failed to load acknowledgements")
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
