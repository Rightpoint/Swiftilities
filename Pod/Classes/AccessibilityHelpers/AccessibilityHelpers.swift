//
//  AccessibilityHelpers.swift
//  Swiftilities
//
//  Created by Michael Skiba on 11/17/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import UIKit

public typealias AccessibilityAnnounceCompletion = (_ anncouncedString: String?, _ success: Bool) -> Void

/// A set of handy UIAccessibility helpers
public class Accessibility: NSObject {

    public static let shared = Accessibility()

    private var announceCompletion: AccessibilityAnnounceCompletion?
    private let concurrentAnnouncementQueue = DispatchQueue(label: "com.raizlabs.announcements.queue")

    public override init() {
        super.init()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(Accessibility.handleAnnounceDidFinish(_:)),
                                               name: NSNotification.Name.UIAccessibilityAnnouncementDidFinish,
                                               object: nil)
    }

    /**
     Check if VoiceOver is currently running (UIAccessibilityIsVoiceOverRunning()).
     */
    public static var isVoiceOverRunning: Bool {
        return UIAccessibilityIsVoiceOverRunning()
    }

    /**
     Announce a message via VoiceOver with optional completion callback (UIAccessibilityAnnouncementNotification).

     - parameter text:       The text to be spoken.
     - parameter completion: A block to be invoked when the announcement has completed.
     */
    public func announce(_ text: String, completion: AccessibilityAnnounceCompletion? = nil) {
        concurrentAnnouncementQueue.sync {
            announceCompletion?(nil, false)
            announceCompletion = completion
        }
        UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, text)
    }

    @objc public func handleAnnounceDidFinish(_ notification: NSNotification) {
        if let userInfo = notification.userInfo {
            concurrentAnnouncementQueue.sync {
                announceCompletion?(userInfo[UIAccessibilityAnnouncementKeyStringValue] as? String,
                                    (userInfo[UIAccessibilityAnnouncementKeyWasSuccessful] as? Bool ?? false))
                announceCompletion = nil
            }
        }
    }

    /**
     Notify VoiceOver that layout has changed and focus on an optionally provided view (UIAccessibilityLayoutChangedNotification).

     - parameter focusView: A view to be focussed on as part of the layout change.
     */
    public func layoutChanged(in focusView: UIView? = nil) {
        UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, focusView)
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
            let cell = self.cellForRow(at: IndexPath(row: 0, section: 0)) else {
                return
        }
        Accessibility.shared.layoutChanged(in: cell)
    }

}
