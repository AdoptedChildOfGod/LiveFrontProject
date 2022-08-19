//
//  MainViewController.swift
//  LiveFrontProject
//
//  Created by Shannon Draeker on 8/19/22.
//

import UIKit

class MainViewController: BaseViewController {
    // MARK: - View Lifecycle

    override func loadView() {
        super.loadView()
        CrashlyticsHelper.log()

        // Show the navigation bar with the app title
        setUpNavBar(withTitle: "The Rules of D&D")

        // Start loading the rules from the server
        RuleController.shared.fetchRules(handleCompletion(with: { [weak self] _ in
            // After it successfully loads, refresh the tableview to show the data
            self?.rulesTableView.reloadData()
        }, { [weak self] _ in
            // Display an error
            RuleController.shared.allRules = []
            self?.rulesTableView.reloadData()
        }))
    }

    // MARK: - UI Elements

    /// The tableview listing all the top level rules
    private lazy var rulesTableView = UITableView(delegate: self, dataSource: self, cellClass: SimpleTableViewCell.self, separator: .singleLine)

    // MARK: - Set Up UI

    /// Add all the subviews to the view
    override func addAllSubviews() {
        view.addSubview(rulesTableView)
    }

    /// Set up the constraints and lay out all the elements in the view
    override func setUpConstraints() {
        // The tableview listing all the top level rules
        rulesTableView.anchorTop(to: view, 4, safeArea: true).anchorBottom(to: view, 10, safeArea: true).anchorCenterX(to: view, 1)
        rulesTableView.separatorColor = .highlight
    }
}

// MARK: - TableView Methods

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    /// The number of rows
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int { RuleController.shared.allRules?.count ?? 1 }

    /// The content of each row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SimpleTableViewCell.identifier, for: indexPath) as? SimpleTableViewCell else { return UITableViewCell() }

        // Fill in the text of the cell with either the selected rule or an appropriate message
        if let allRules = RuleController.shared.allRules {
            if let ruleName = allRules[safe: indexPath.row]?.name {
                cell.setUp(with: ruleName)
            } else {
                cell.setUp(with: "There was an error - please try again", useArrow: false)
            }
        } else {
            cell.setUp(with: "Please wait while the rules load...", useArrow: false)
        }

        return cell
    }

    /// When a row is tapped
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Get the selected rule
        guard let selectedRule = RuleController.shared.allRules?[safe: indexPath.row] else { return }
        guard let index = selectedRule.index, let url = selectedRule.url else { return CrashlyticsHelper.recordUnexpectedNil("index or url") }

        // Start the loading icon and load the rule
        view.startLoadingIcon()
        RuleController.shared.fetchRule(withIndex: index, andURL: url, completion: handleCompletion(with: { [weak self] (rule: Rule?) in
            // Go to the next page to display the selected rule
            self?.coordinator?.goTo(DetailViewController()) { $0.rule = rule }
        }))
    }
}
