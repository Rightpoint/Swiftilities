//
//  AcknowledgementsListViewController.swift
//  Swiftilities
//
//  Created by Michael Skiba on 11/21/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import UIKit

open class AcknowledgementsListViewController: UITableViewController {

    fileprivate static let reuseID = "com.raizlabs.acknowledgements.standardCell"

    public var childViewControllerClass: AcknowledgementViewController.Type = AcknowledgementViewController.self

    public enum LocalizedStrings {
        public static let acknowlegementsTitle = NSLocalizedString("Acknowledgements", comment: "Default title for the Acknowlegements view controller from Swiftilities")
    }

    open var viewModel: AcknowledgementsListViewModel = AcknowledgementsListViewModel(title: "", acknowledgements: []) {
        didSet {
            tableView.reloadData()
        }
    }

    open var licenseFormatter: (String) -> NSAttributedString = AcknowledgementViewController.defaultLicenseFormatter

    open var licenseViewBackgroundColor: UIColor?

    open var cellBackgroundColor: UIColor? {
        didSet {
            tableView.reloadData()
        }
    }

    public convenience init(title: String = LocalizedStrings.acknowlegementsTitle,
                            viewModel: AcknowledgementsListViewModel,
                            licenseFormatter: @escaping (String) -> NSAttributedString = AcknowledgementViewController.defaultLicenseFormatter) {
        self.init(style: .plain)
        self.navigationItem.title = title
        self.viewModel = viewModel
        self.licenseFormatter = licenseFormatter
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: AcknowledgementsListViewController.reuseID)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.smoothlyDeselectItems(tableView)
    }

    // MARK: - Table view data source

    override open func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.acknowledgements.isEmpty ? 0 : 1
    }

    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.acknowledgements.count
    }

    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AcknowledgementsListViewController.reuseID, for: indexPath)
        cell.accessoryType = .disclosureIndicator
        if let backgroundColor = cellBackgroundColor {
            cell.backgroundColor = backgroundColor
        }
        cell.textLabel?.text = viewModel.acknowledgements[indexPath.row].title
        return cell
    }

    // MARK: Table view delegate
    override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let entry = viewModel.acknowledgements[indexPath.row]
        let acknowledgementVC = childViewControllerClass.init(viewModel: entry,
                                                         licenseFormatter: licenseFormatter,
                                                         viewBackgroundColor: licenseViewBackgroundColor)
        navigationController?.pushViewController(acknowledgementVC, animated: true)
    }

}
