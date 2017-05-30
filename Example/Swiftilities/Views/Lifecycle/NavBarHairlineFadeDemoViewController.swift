//
//  NavBarHairlineFadeDemoViewController.swift
//  Swiftilities
//
//  Created by Jason Clark on 5/26/17.
//  Copyright © 2017 Raizlabs. All rights reserved.
//

import Swiftilities

final class NavBarHairlineFadeDemoViewController: UIViewController {

    let scrollView = UIScrollView()
    let titleLabel = UILabel()
    let contentView = UIView()

    override func viewDidLoad() {
        navigationItem.title = "Nav Bar Hairline Fade"
        titleLabel.text = "Scroll View"

        let navBar = navigationController?.navigationBar
        navBar?.setBackgroundImage(UIImage(), for: .default)
        navBar?.shadowImage = UIImage()
        navBar?.backgroundColor = .white
        navBar?.isTranslucent = false

        view.backgroundColor = .white
        let behavior = NavBarHarilineFadeBehavior(scrollView: scrollView)
        addBehaviors([behavior])
    }

}

extension NavBarHairlineFadeDemoViewController {

    override func loadView() {
        view = UIView()
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(titleLabel)
        for view in [scrollView, titleLabel, contentView] {
            view.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            contentView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 2),

            titleLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 200),
            ])
    }

}
