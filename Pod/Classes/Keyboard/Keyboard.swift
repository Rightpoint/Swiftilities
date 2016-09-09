//
//  Keyboard.swift
//  Swiftilities
//
//  Created by Rob Visentin on 2/5/16.
//  Copyright © 2016 Raizlabs Inc. All rights reserved.
//
// Copyright 2016 Raizlabs and other contributors
// http://raizlabs.com/
//

import UIKit

/**
 *  A set of abstractions around the keyboard.
 */
final class Keyboard {

    typealias FrameChangeHandler = (CGRect) -> Void

    #if swift(>=3.0)
        fileprivate(set) static var frame: CGRect = .zero
        fileprivate static var notificationObserver: NSObjectProtocol?
        fileprivate static let frameObservers = NSMapTable<AnyObject, AnyObject>.weakToStrongObjects()
    #else
        private(set) static var frame: CGRect = .zero
        private static var notificationObserver: NSObjectProtocol?
        private static let frameObservers = NSMapTable.weakToStrongObjects()
    #endif

    #if swift(>=3.0)
    /**
     Add a keyboard frame observer with associated handler. Perform view changes in the handler to have them tied to the animation
     characteristics of the keyboard frame changes.
     
     - parameter observer: The object that will act as the observer for keyboard frame changes. NOTE: this object is not strongly held, therefore a corresponding call to remove is not required.
     - parameter animated: Whether or not to animate changes in the handler block alongside the keyboard frame changes.
     - parameter handler:  A block in which to perform view changes.
     */
    static func addFrameObserver(_ observer: AnyObject, withAnimations animated: Bool = true, handler: FrameChangeHandler) {
        frameObservers.setObject(KeyboardHandler(handler: handler, animated: animated), forKey: observer)

        if notificationObserver == nil {
            setupObservers()
        }
    }

    /**
     Remove the object as a keyboard frame observer. NOTE: observer is not strongly held, therefore this method is purely optional.
     
     - parameter observer: The object being observed to remove.
     */
    static func removeFrameObserver(_ observer: AnyObject) {
        frameObservers.removeObject(forKey: observer)

        if frameObservers.count == 0 {
            teardownObservers()
        }
    }
    #else
    /**
     Add a keyboard frame observer with associated handler. Perform view changes in the handler to have them tied to the animation
     characteristics of the keyboard frame changes.

     - parameter observer: The object that will act as the observer for keyboard frame changes. NOTE: this object is not strongly held, therefore a corresponding call to remove is not required.
     - parameter animated: Whether or not to animate changes in the handler block alongside the keyboard frame changes.
     - parameter handler:  A block in which to perform view changes.
     */
    static func addFrameObserver(observer: AnyObject, withAnimations animated: Bool = true, handler: FrameChangeHandler) {
    frameObservers.setObject(KeyboardHandler(handler: handler, animated: animated), forKey: observer)

    if notificationObserver == nil {
    setupObservers()
    }
    }

    /**
     Remove the object as a keyboard frame observer. NOTE: observer is not strongly held, therefore this method is purely optional.

     - parameter observer: The object being observed to remove.
     */
    static func removeFrameObserver(observer: AnyObject) {
    frameObservers.removeObjectForKey(observer)

    if frameObservers.count == 0 {
    teardownObservers()
    }
    }
    #endif

}

extension UIViewAnimationCurve {

    #if swift(>=3.0)
    func animationOption() -> UIViewAnimationOptions {
        switch self {
        case .easeInOut: return UIViewAnimationOptions()
        case .easeIn:    return .curveEaseIn
        case .easeOut:   return .curveEaseOut
        case .linear:    return .curveLinear
        }
    }
    #else
    func animationOption() -> UIViewAnimationOptions {
    switch self {
    case .EaseInOut: return .CurveEaseInOut
    case .EaseIn:    return .CurveEaseIn
    case .EaseOut:   return .CurveEaseOut
    case .Linear:    return .CurveLinear
    }
    }
    #endif

}

// MARK: - Private

private extension Keyboard {

    #if swift(>=3.0)
    static func setupObservers() {
        notificationObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil, queue: .main) { notification -> Void in
            guard let frameValue: NSValue  = (notification as NSNotification).userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue else {
                return
            }
            frame = frameValue.cgRectValue
            let handlers = frameObservers.objectEnumerator()

            while let handler = handlers?.nextObject() as? KeyboardHandler<FrameChangeHandler> {
                if let durationValue = (notification as NSNotification).userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber , handler.animated {

                    let curveValue = ((notification as NSNotification).userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber)?.intValue
                    let curve = UIViewAnimationCurve(rawValue: curveValue ?? 0)
                    let animationOption = curve?.animationOption() ?? UIViewAnimationOptions()

                    UIView.animate(withDuration: durationValue.doubleValue, delay: 0.0, options: animationOption, animations: {
                        handler.handler(frame)
                    }, completion: nil)
                }
                else {
                    handler.handler(frame)
                }
            }
        }
    }

    static func teardownObservers() {
        if let notificationObserver = notificationObserver {
            NotificationCenter.default.removeObserver(notificationObserver)
            self.notificationObserver = nil
        }
    }
    #else
    static func setupObservers() {
    notificationObserver = NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillChangeFrameNotification, object: nil, queue: .mainQueue()) { notification -> Void in
    guard let frameValue: NSValue  = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue else {
    return
    }
    frame = frameValue.CGRectValue()

    let handlers = frameObservers.objectEnumerator()

    while let handler = handlers?.nextObject() as? KeyboardHandler<FrameChangeHandler> {
    if let durationValue = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber where handler.animated {

    let curveValue = (notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber)?.integerValue
    let curve = UIViewAnimationCurve(rawValue: curveValue ?? 0)
    let animationOption = curve?.animationOption() ?? .CurveEaseInOut

    UIView.animateWithDuration(durationValue.doubleValue, delay: 0.0, options: animationOption, animations: {
    handler.handler(frame)
    }, completion: nil)
    }
    else {
    handler.handler(frame)
    }
    }
    }
    }

    static func teardownObservers() {
    if let notificationObserver = notificationObserver {
    NSNotificationCenter.defaultCenter().removeObserver(notificationObserver)
    self.notificationObserver = nil
    }
    }
    #endif

}

private final class KeyboardHandler<T> {

    let handler: T
    let animated: Bool

    init(handler: T, animated: Bool) {
        self.handler = handler
        self.animated = animated
    }

}
