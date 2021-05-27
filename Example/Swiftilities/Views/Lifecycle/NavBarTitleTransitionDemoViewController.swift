//
//  NavBarTitleTransitionDemoViewController.swift
//  Swiftilities
//
//  Created by Jason Clark on 5/26/17.
//  Copyright © 2017 Raizlabs. All rights reserved.
//

import Swiftilities

class NavBarTitleTransitionDemoViewController: UIViewController {

    let scrollView = UIScrollView()
    let titleLabel = UILabel()
    let contentView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Title Transition"
        titleLabel.text = "Title Transition"
        view.backgroundColor = .lightGray

        let behavior = NavTitleTransitionBehavior(scrollView: scrollView, titleView: titleLabel)
        addBehaviors([behavior])
    }

}

extension NavBarTitleTransitionDemoViewController {

    override func loadView() {
        Log.trace("NavBarTransition", type: .begin)
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
        Log.trace("NavBarTransition", type: .end)
    }

}
