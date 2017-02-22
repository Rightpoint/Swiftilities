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
            let viewModel = try AcknowledgementsListViewModel(plistNamed: "Pods-Swiftilities_Example-acknowledgements")
            let viewController = LightGrayListViewController(viewModel: viewModel)
            viewController.childViewControllerClass = LightGrayAcknowlegement.self
            navigationController?.pushViewController(viewController, animated: true)
        }
        catch {
            fatalError("Failed to load acknowledgements")
        }
    }

    @IBAction func demonstrateRootViewControllerCycling(_ sender: Any) {
        let v1 = UIViewController()
        v1.view.backgroundColor = .red
        let v2 = UIViewController()
        v2.view.backgroundColor = .blue
        guard let v3 = storyboard?.instantiateInitialViewController(),
            let window = UIApplication.shared.keyWindow else {
            return
        }
        present(v1, animated: true) {
            window.setRootViewController(v2, animated: true) {
                window.setRootViewController(v3, animated: true)
            }
        }
    }

}

private class LightGrayListViewController: AcknowledgementsListViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(rgba: 0xDDDDDDFF)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.backgroundColor = UIColor(rgba: 0xDDDDDDFF)
        return cell
    }
}

private class LightGrayAcknowlegement: AcknowledgementViewController {

    override func loadView() {
        super.loadView()
        view.backgroundColor = UIColor(rgba: 0xDDDDDDFF)
    }

}
