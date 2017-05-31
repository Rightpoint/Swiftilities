//
//  LifecycleBehaviorsListViewController.swift
//  Swiftilities
//
//  Created by Jason Clark on 5/30/17.
//  Copyright © 2017 Raizlabs. All rights reserved.
//

import UIKit

class LifecycleBehaviorsListViewController: UIViewController {

    @IBAction func hairlineDemoSelected() {
        let vc = NavBarHairlineFadeDemoViewController()
        vc.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(dismissPressed))
        let nav = UINavigationController(rootViewController: vc)
        let navBar = nav.navigationBar
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        navBar.backgroundColor = .white
        navBar.isTranslucent = false
        present(nav, animated: true, completion: nil)
    }

    @IBAction func titleTransitionDemoSelected() {
        let vc = NavBarTitleTransitionDemoViewController()
        vc.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(dismissPressed))
        let nav = UINavigationController(rootViewController: vc)
        let navBar = nav.navigationBar
        navBar.isTranslucent = false
        present(nav, animated: true, completion: nil)
    }

    @objc func dismissPressed() {
        dismiss(animated: true, completion: nil)
    }
}
