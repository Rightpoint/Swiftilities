//
//  LifecycleBehaviorViewController.swift
//  Swiftilities
//
//  Created by Nicholas Bonatsakis on 6/10/16.
//  Copyright© 2016 Raizlabs
//
//  Based on concepts and examples in:
//  http://khanlou.com/2016/02/many-controllers/ and
//  http://irace.me/lifecycle-behaviors

import UIKit

final class LifecycleBehaviorViewController: UIViewController {

    fileprivate let behaviors: [ViewControllerLifecycleBehavior]

    // MARK: - Initialization

    init(behaviors: [ViewControllerLifecycleBehavior]) {
        self.behaviors = behaviors

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        view.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        applyBehaviors { behavior, viewController in
            behavior.beforeAppearing(viewController, animated: animated)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        applyBehaviors { behavior, viewController in
            behavior.afterAppearing(viewController, animated: animated)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        applyBehaviors { behavior, viewController in
            behavior.beforeDisappearing(viewController, animated: animated)
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        applyBehaviors { behavior, viewController in
            behavior.afterDisappearing(viewController, animated: animated)
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        applyBehaviors { behavior, viewController in
            behavior.beforeLayingOutSubviews(viewController)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        applyBehaviors { behavior, viewController in
            behavior.afterLayingOutSubviews(viewController)
        }
    }

}

private extension LifecycleBehaviorViewController {

    typealias BehaviorApplication = (_ behavior: ViewControllerLifecycleBehavior,
                                     _ viewController: UIViewController) -> Void

    func applyBehaviors(body: BehaviorApplication) {
        guard let parentViewController = parent else { return }

        for behavior in behaviors {
            body(behavior, parentViewController)
        }
    }

}
