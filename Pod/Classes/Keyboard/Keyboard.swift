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
// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to
// the following conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
// LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
// OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import UIKit

/**
 *  A set of abstractions around the keyboard.
 */
final class Keyboard {

    typealias FrameChangeHandler = CGRect -> Void

    private(set) static var frame: CGRect = .zero

    private static var notificationObserver: NSObjectProtocol?
    private static let frameObservers = NSMapTable.weakToStrongObjectsMapTable()

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

}

extension UIViewAnimationCurve {
    
    func animationOption() -> UIViewAnimationOptions {
        switch self {
        case .EaseInOut: return .CurveEaseInOut
        case .EaseIn:    return .CurveEaseIn
        case .EaseOut:   return .CurveEaseOut
        case .Linear:    return .CurveLinear
        }
    }
    
}

// MARK: - Private

private extension Keyboard {

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

}

private final class KeyboardHandler<T> {

    let handler: T
    let animated: Bool

    init(handler: T, animated: Bool) {
        self.handler = handler
        self.animated = animated
    }

}
