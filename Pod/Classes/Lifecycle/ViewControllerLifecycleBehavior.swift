//
//  ViewControllerLifecycleBehavior.swift
//  Swiftilities
//
//  Created by Nicholas Bonatsakis on 6/10/16.
//  Copyright© 2016 Raizlabs
//
//  Based on concepts and examples in:
//  http://khanlou.com/2016/02/many-controllers/ and
//  http://irace.me/lifecycle-behaviors

import UIKit

public protocol ViewControllerLifecycleBehavior {

    func beforeAppearing(_ viewController: UIViewController, animated: Bool)

    func afterAppearing(_ viewController: UIViewController, animated: Bool)

    func beforeDisappearing(_ viewController: UIViewController, animated: Bool)

    func afterDisappearing(_ viewController: UIViewController, animated: Bool)

    func beforeLayingOutSubviews(_ viewController: UIViewController)

    func afterLayingOutSubviews(_ viewController: UIViewController)

}

public extension ViewControllerLifecycleBehavior {

    public func beforeAppearing(_ viewController: UIViewController, animated: Bool) {}

    public func afterAppearing(_ viewController: UIViewController, animated: Bool) {}

    public func beforeDisappearing(_ viewController: UIViewController, animated: Bool) {}

    public func afterDisappearing(_ viewController: UIViewController, animated: Bool) {}

    public func beforeLayingOutSubviews(_ viewController: UIViewController) {}

    public func afterLayingOutSubviews(_ viewController: UIViewController) {}

}
