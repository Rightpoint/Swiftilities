//
//  Keyboard.swift
//  Swiftilities
//
//  Created by Rob Visentin on 2/5/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import UIKit

/**
 *  A set of abstractions around the keyboard.
 */
public class Keyboard {

    public typealias FrameChangeHandler = (CGRect) -> Void

    fileprivate(set) static var frame: CGRect = .zero

    fileprivate static var notificationObserver: NSObjectProtocol?
    fileprivate static let frameObservers = NSMapTable<AnyObject, AnyObject>.weakToStrongObjects()

    /**
     Add a keyboard frame observer with associated handler. Perform view changes in the handler to have them tied to the animation
     characteristics of the keyboard frame changes.

     - parameter observer: The object that will act as the observer for keyboard frame changes. NOTE: this object is not strongly held, therefore a corresponding call to remove is not required.
     - parameter animated: Whether or not to animate changes in the handler block alongside the keyboard frame changes.
     - parameter handler:  A block in which to perform view changes.
     */
    public static func addFrameObserver(_ observer: AnyObject, withAnimations animated: Bool = true, handler: @escaping FrameChangeHandler) {
        frameObservers.setObject(KeyboardHandler(handler: handler, animated: animated), forKey: observer)

        if notificationObserver == nil {
            setupObservers()
        }
    }

    /**
     Remove the object as a keyboard frame observer. NOTE: observer is not strongly held, therefore this method is purely optional.

     - parameter observer: The object being observed to remove.
     */
    public static func removeFrameObserver(_ observer: AnyObject) {
        frameObservers.removeObject(forKey: observer)

        if frameObservers.count == 0 {
            teardownObservers()
        }
    }

}

extension UIView.AnimationCurve {
    func animationOptions() -> UIView.AnimationOptions {
        switch self {
        case .easeInOut: return .curveEaseInOut
        case .easeIn:    return .curveEaseIn
        case .easeOut:   return .curveEaseOut
        case .linear:    return .curveLinear
        default:
            // Some private UIViewAnimationCurve values unknown to the compiler can leak through notifications.
            return UIView.AnimationOptions(rawValue: UInt(rawValue << 16))
        }
    }
}

// MARK: - Private

private extension Keyboard {
    static func setupObservers() {
        notificationObserver = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification, object: nil, queue: .main) { notification -> Void in
            guard let frameValue: NSValue = (notification as NSNotification).userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
                return
            }
            frame = frameValue.cgRectValue

            let handlers = frameObservers.objectEnumerator()

            while let handler = handlers?.nextObject() as? KeyboardHandler<FrameChangeHandler> {
                if let durationValue = (notification as NSNotification).userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber, handler.animated {

                    let curveValue = ((notification as NSNotification).userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.intValue
                    let curve = curveValue.flatMap(UIView.AnimationCurve.init) ?? .easeInOut

                    UIView.animate(withDuration: durationValue.doubleValue, delay: 0.0, options: curve.animationOptions(), animations: {
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

}

private final class KeyboardHandler<T> {

    let handler: T
    let animated: Bool

    init(handler: T, animated: Bool) {
        self.handler = handler
        self.animated = animated
    }

}
