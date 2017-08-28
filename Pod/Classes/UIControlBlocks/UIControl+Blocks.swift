//
//  UIControl+Blocks.swift
//  Base
//
//  Created by Brian King on 6/23/17.
//
//

import UIKit

public protocol BlockControl {}

extension UIControl: BlockControl {}

public extension BlockControl where Self: UIControl {
    /**
     Set a callback to use for an event. Only one callback can be set per event, and multiple
     invocations will remove the previously set callback.

     - parameter event: A UIControlEvents value
     - parameter callback: The event handler callback
     */
    func setCallback(for events: UIControlEvents, _ callback: @escaping (Self) -> Void) {
        let target = BlockControlTarget { (control) in
            guard let control = control as? Self else { fatalError("") }
            callback(control)
        }
        blockTargets[events.rawValue] = target
        addTarget(target, action: #selector(BlockControlTarget.recognized(_:)), for: events)
    }

    /**
     Removes the callback registered for the specified events.

     - parameter events: The specific event to clear. If not specified, all registered events are removed.
     - parameter callback: The event handler function
     */
    func clearCallbacks(for events: UIControlEvents? = nil) {
        if let events = events {
            blockTargets.removeValue(forKey: events.rawValue)
        }
        else {
            blockTargets.removeAll()
        }
    }

}

private class BlockControlTarget {
    let callback: (UIControl) -> Void

    init(callback: @escaping (UIControl) -> Void) {
        self.callback = callback
    }

    @objc func recognized(_ control: UIControl) {
        callback(control)
    }
}

// MARK: Proxy
private var key = "com.raizlabs.blocktarget"

private extension UIControl {
    final var blockTargets: [UInt: BlockControlTarget] {
        get {
            return objc_getAssociatedObject(self, &key) as? [UInt: BlockControlTarget] ?? [:]
        }

        set {
            objc_setAssociatedObject(self, &key, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}
