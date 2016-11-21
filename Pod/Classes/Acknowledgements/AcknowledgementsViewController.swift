//
//  AcknowledgementsViewController.swift
//  Swiftilities
//
//  Created by Michael Skiba on 11/21/16.
//  Copyright © 2016 Raizlabs Inc. All rights reserved.
//

import UIKit

open class AcknowledgementsViewController: UITableViewController {

    fileprivate static let reuseID = "entryCell"

    public enum LocalizedStrings {
        public static let acknowlegementsTitle = NSLocalizedString("Acknowlegments", comment: "Default title for the Acknowlegements view controller from Swiftilities")
    }

    open var viewModel: AcknowledgementsViewModel = AcknowledgementsViewModel(title: "", acknowledgements: []) {
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

    open var registeredCellClass: UITableViewCell.Type = UITableViewCell.self {
        didSet{
            updateCellRegistration()
        }
    }

    public  convenience init(title: String = LocalizedStrings.acknowlegementsTitle,
                             viewModel: AcknowledgementsViewModel, licenseViewBackgroundColor: UIColor? = nil, cellBackgroundColor: UIColor? = nil, registeredCellClass: UITableViewCell.Type = UITableViewCell.self, licenseFormatter: @escaping (String) -> NSAttributedString = AcknowledgementViewController.defaultLicenseFormatter) {
        self.init(style: .plain)
        self.navigationItem.title = title
        self.viewModel = viewModel
        self.licenseFormatter = licenseFormatter
        self.licenseViewBackgroundColor = licenseViewBackgroundColor
        self.registeredCellClass = registeredCellClass
        self.cellBackgroundColor = cellBackgroundColor
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        updateCellRegistration()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: AcknowledgementsViewController.reuseID, for: indexPath)
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
        let acknowledgementVC = AcknowledgementViewController(viewModel: entry,
                                                              licenseFormatter: licenseFormatter,
                                                              viewBackgroundColor: licenseViewBackgroundColor)
        navigationController?.pushViewController(acknowledgementVC, animated: true)
    }

}

private extension AcknowledgementsViewController {

    func updateCellRegistration() {
        tableView.register(self.registeredCellClass, forCellReuseIdentifier: AcknowledgementsViewController.reuseID)
        tableView.reloadData()
    }

}
