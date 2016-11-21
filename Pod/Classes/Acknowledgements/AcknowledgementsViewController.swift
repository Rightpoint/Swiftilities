//
//  AcknowledgementsViewController.swift
//  Swiftilities
//
//  Created by Michael Skiba on 11/21/16.
//  Copyright © 2016 Raizlabs Inc. All rights reserved.
//

import UIKit

open class AcknowledgementsViewController: UITableViewController {

    public enum LocalizedStrings {
        public static let acknowlegementsTitle = NSLocalizedString("Acknowlegments", comment: "Default title for the Acknowlegements view controller from Swiftilities")
    }

    var viewModel: AcknowledgementsViewModel = AcknowledgementsViewModel(title: "", entries: []) {
        didSet {
            tableView.reloadData()
        }
    }

    var licenseFormatter: (String) -> NSAttributedString = AcknowledgementViewController.defaultLicenseFormatter

    public convenience init(title: String = LocalizedStrings.acknowlegementsTitle,
                            viewModel: AcknowledgementsViewModel, licenseFormatter: @escaping (String) -> NSAttributedString = AcknowledgementViewController.defaultLicenseFormatter) {
        self.init(style: .plain)
        self.navigationItem.title = title
        self.viewModel = viewModel
        self.licenseFormatter = licenseFormatter
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.smoothlyDeselectItems(tableView)
    }
}

extension AcknowledgementsViewController {

    // MARK: - Table view data source

    override open func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.entries.isEmpty ? 0 : 1
    }

    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.entries.count
    }

    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseID = "entryCell"
        let cell: UITableViewCell
        if let existingCell = tableView.dequeueReusableCell(withIdentifier: reuseID) {
            cell = existingCell
        } else {
            cell = UITableViewCell(style: .default, reuseIdentifier: reuseID)
            cell.accessoryType = .disclosureIndicator
        }

        cell.textLabel?.text = viewModel.entries[indexPath.row].title

        return cell
    }

    // MARK: Table view delegate

    override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let entry = viewModel.entries[indexPath.row]
        let acknowledgementVC = AcknowledgementViewController(viewModel: entry,
                                                              licenseFormatter: licenseFormatter)
        navigationController?.pushViewController(acknowledgementVC, animated: true)
    }
    
}
