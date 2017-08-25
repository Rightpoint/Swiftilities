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
     Set a block handler for an event.

     - parameter event: A UIControlEvents event
     - parameter callback: The event handler function
     */
    func setBlockTarget(for event: UIControlEvents, callback: @escaping (Self) -> Void) {
        let target = BlockTarget() { (control) in
            guard let control = control as? Self else { fatalError("") }
            callback(control)
        }
        blockTargets[event.rawValue] = target
        addTarget(target, action: #selector(BlockTarget.recognized(_:)), for: event)
    }

    /**
     Set a block handler for multiple events.

     - parameter event: A UIControlEvents event
     - parameter callback: The event handler function
     */
    func setBlockTarget(for events: [UIControlEvents], callback: @escaping (Self) -> Void) {
        for event in events {
            setBlockTarget(for: event, callback: callback)
        }
    }

    /**
     Removes the block handlers for the specified events.

     - parameter events: The specific events to clear. If not specified, all registered events are removed.
     - parameter callback: The event handler function
     */
    func clearBlockTargets(for events: [UIControlEvents]? = nil) {
        if let events = events {
            for event in events {
                blockTargets.removeValue(forKey: event.rawValue)
            }
        }
        else {
            blockTargets.removeAll()
        }
    }

}

private class BlockTarget {
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
    final var blockTargets: [UInt: BlockTarget] {
        get {
            return objc_getAssociatedObject(self, &key) as? [UInt: BlockTarget] ?? [:]
        }

        set {
            objc_setAssociatedObject(self, &key, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}
