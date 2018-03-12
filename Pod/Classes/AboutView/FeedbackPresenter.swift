//
//  FeedbackPresenter.swift
//  Swiftilities
//
//  Created by Michael Skiba on 2/28/17.
//  Copyright © 2017 Raizlabs. All rights reserved.
//

import MessageUI
import UIKit

private class AboutMailViewController: MFMailComposeViewController {

    var mailCompletionHandler: ((MFMailComposeResult) -> Void)?

}

extension AboutMailViewController: MFMailComposeViewControllerDelegate {

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        let completion = (controller as? AboutMailViewController)?.mailCompletionHandler
        controller.dismiss(animated: true) {
            completion?(result)
        }
    }

}

public protocol FeedbackPresenter {
}

public extension FeedbackPresenter where Self: UIViewController {

    /// Presents a self-dismissing MFMailComposeViewController view controller pre-populated with app version
    /// and device info
    ///
    /// MFMailComposeViewController does not support the full set of customizations that can be applied to other
    /// UINavigationControllers. If you use appearance proxies directly on UINavigationController you may need to reset
    /// some of the configurations that you use before presenting the mail compose view controller. An alternative
    /// option is to subclass UINavigationController for all of the customized view controllers in you app any use the
    /// UIAppearance proxy on the subclass so that none of the custom styling crosses over mail compose and other system
    /// navigation controllers.
    ///
    /// - Parameters:
    ///   - email: the email address that feedback should be sent to
    ///   - completion: a completion handler to be executed after the mail compose view controller is dismissed
    public func presentSendFeedback(to email: String, completion: ((MFMailComposeResult) -> Void)?) {
        let deviceModel = AppInfo.deviceModel
        guard deviceModel != "i386", deviceModel != "x86_64" else {
            let alert = UIAlertController(title: "Not supported in simulator",
                                          message: "The mail compose view is not supported in the simulator",
                                          preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel) { _ in
                completion?(MFMailComposeResult.failed)
            }
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
            return
        }
        let mailViewController = AboutMailViewController()
        mailViewController.mailCompletionHandler = completion
        mailViewController.mailComposeDelegate = mailViewController

        let subject = String(format: NSLocalizedString("%@ (%@) Feedback", comment: "E-mail feedback subject format."), AppInfo.name, AppInfo.version)
        let body = String(format: NSLocalizedString("\n\n\n-----\nVersion: %@ (%@)\nDevice: %@\n", comment: "E-mail feeback body format"), AppInfo.version, AppInfo.buildNumber, AppInfo.deviceModel)

        mailViewController.setToRecipients([email])
        mailViewController.setSubject(subject)
        mailViewController.setMessageBody(body, isHTML: false)
        present(mailViewController, animated: true, completion: nil)
    }

    /// Present a share sheet with a string and URL from a UIView that is not a UIBarButtonItem
    ///
    /// - Parameters:
    ///   - shareText: The text to share
    ///   - shareURL: The URL to share
    ///   - anchorView: The view to anchor the presented view to on the iPad
    ///   - frame: The frame to anchor the presented view to on the iPad, if the value is nil it will default to the
    ///            frame of the anchor view
    public func presentShareApp(shareText: NSString, shareURL: URL, presentedFrom anchorView: UIView, with frame: CGRect? = nil) {
        let activityViewController = UIActivityViewController(activityItems: [shareText, shareURL], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = anchorView
        activityViewController.popoverPresentationController?.sourceRect = frame ?? anchorView.frame
        present(activityViewController, animated: true, completion: nil)
    }

    /// Present a share sheet with a string and URL from a UIBarButtonItem
    ///
    /// - Parameters:
    ///   - shareText: The text to share
    ///   - shareURL: The URL to share
    ///   - barButtonItem: The UIBarButtonItem to anchor to on it iPad
    public func presentShareApp(shareText: NSString, shareURL: URL, presentedFrom barButtonItem: UIBarButtonItem) {
        let activityViewController = UIActivityViewController(activityItems: [shareText, shareURL], applicationActivities: nil)
        activityViewController.popoverPresentationController?.barButtonItem = barButtonItem
        present(activityViewController, animated: true, completion: nil)
    }

}
