//
//  MainViewController.swift
//  LiveFrontProject
//
//  Created by Shannon Draeker on 8/19/22.
//

import Foundation

import UIKit

class MainViewController: BaseViewController {
    // MARK: - View Lifecycle

    override func loadView() {
        super.loadView()
        CrashlyticsHelper.log()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Hide the navigation bar on this view
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    // MARK: - UI Elements

    /// The title of the page
    private let titleBackgroundView = UIView(color: .darkHighlight)
    private let titleLabel = UILabel("The Rules of D&D", fontSize: 32, fontName: .bold, autoResize: false)

    /// The tableview listing all the top level rules
    private lazy var rulesTableView = UITableView(delegate: self, dataSource: self, cellClass: UITableViewCell.self, separator: .singleLine)

    // MARK: - Set Up UI

    /// Add all the subviews to the view
    override func addAllSubviews() {
        view.addSubviews(titleBackgroundView, titleLabel, rulesTableView)
    }

    /// Set up the constraints and lay out all the elements in the view
    override func setUpConstraints() {
        // The title of the page
        titleBackgroundView.anchorTop(to: view).anchorCenterX(to: view, 1)
        titleLabel.anchorTop(to: view, 10, safeArea: true).anchorBottom(to: titleBackgroundView, 10).anchorCenterX(to: view)

        // The tableview listing all the top level rules
        rulesTableView.anchorBelow(titleBackgroundView, 10).anchorBottom(to: view, 10, safeArea: true).anchorCenterX(to: view, 1)
    }
}

// MARK: - TableView Methods

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    /// The number of rows
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int { RuleController.shared.allRules?.count ?? 1 }

    /// The content of each row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.identifier, for: indexPath)

        // Format the cell
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        cell.textLabel?.textColor = .text

        // Fill in the text of the cell with either the selected rule or an appropriate message
        if let allRules = RuleController.shared.allRules {
            if let rule = allRules[safe: indexPath.row] {
                cell.textLabel?.text = rule.name
                cell.accessoryType = .disclosureIndicator
            } else {
                cell.textLabel?.text = "There was an error - please try again"
                cell.accessoryType = .none
            }
        } else {
            cell.textLabel?.text = "Please wait while the rules load..."
            cell.accessoryType = .none
        }

        return cell
    }

    /// When a row is tapped
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Get the selected rule
        guard let rule = RuleController.shared.allRules?[safe: indexPath.row] else { return }

        // Go the next page
    }
}
