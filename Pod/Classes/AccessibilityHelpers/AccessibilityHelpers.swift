//
//  AccessibilityHelpers.swift
//  Swiftilities
//
//  Created by Michael Skiba on 11/17/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import UIKit

public typealias AccessibilityAnnounceCompletion = (_ anncouncedString: String?, _ success: Bool) -> Void

/**
 A set of handy UIAccessibility helpers.
 
 ```
 let accessibility = Accessibility.shared
 if accessibility.isVoiceOverRunning {
    accessibility.announce("Hello World!") { (string, success) in
        if success {
            print("Announced '\(string)'")
        } else {
            print("Did not announce '\(string)'")
        }
    }
 }
 ```
 */
public class Accessibility: NSObject {

    public static let shared = Accessibility()

    private var announceString: String?
    private var announceCompletion: AccessibilityAnnounceCompletion?
    private let announcementQueue = DispatchQueue(label: "com.raizlabs.announcements.queue")

    private override init() {
        super.init()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(Accessibility.handleAnnounceDidFinish(_:)),
                                               name: UIAccessibility.announcementDidFinishNotification,
                                               object: nil)
    }

    /**
     Check if VoiceOver is currently running (UIAccessibility.isVoiceOverRunning).
     */
    public var isVoiceOverRunning: Bool {
        return UIAccessibility.isVoiceOverRunning
    }

    /**
     Announce a message via VoiceOver with optional completion callback (UIAccessibility.Notification.announcement).

     - parameter text:       The text to be spoken.
     - parameter completion: A block to be invoked when the announcement has completed.
     */
    public func announce(_ text: String, completion: AccessibilityAnnounceCompletion? = nil) {
        announcementQueue.sync {
            announceCompletion?(announceString, false)
            announceString = text
            announceCompletion = completion
        }
        UIAccessibility.post(notification: .announcement, argument: text)
    }

    @objc public func handleAnnounceDidFinish(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            announcementQueue.sync {
                announceCompletion?(userInfo[UIAccessibility.announcementStringValueUserInfoKey] as? String,
                                    (userInfo[UIAccessibility.announcementWasSuccessfulUserInfoKey] as? Bool ?? false))
                announceString = nil
                announceCompletion = nil
            }
        }
    }

    /**
     Notify VoiceOver that layout has changed and focus on an optionally provided view (UIAccessibility.Notification.layoutChanged).

     - parameter focusView: A view to be focussed on as part of the layout change.
     */
    public func layoutChanged(in focusView: UIView? = nil) {
        UIAccessibility.post(notification: .layoutChanged, argument: focusView)
    }

}

// MARK: - UIAccessibility helpers for UITableView
public extension UITableView {

    /**
     Focus the VoiceOver layout on the first cell of this UITableView instance.
     If the table view has no rows, this is a no-op.
     */
    @nonobjc public func accessibilityFocusOnFirstCell() {
        guard let sections = dataSource?.numberOfSections?(in: self), sections > 0,
            let rows = dataSource?.tableView(self, numberOfRowsInSection: 0), rows > 0,
            let cell = cellForRow(at: IndexPath(row: 0, section: 0)) else {
                return
        }
        Accessibility.shared.layoutChanged(in: cell)
    }

}
