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
        setUpNavBar(withTitle: NSLocalizedString("rules", comment: "Rules title"))

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

    // MARK: - Actions

    /// Start the loading icon (written inside a selector for more control over timing)
    @objc private func startLoadingIcon() {
        DispatchQueue.main.async { [weak self] in self?.view.startLoadingIcon() }
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
                cell.setUp(with: NSLocalizedString("error_try_again", comment: "Error message"), useArrow: false)
            }
        } else {
            cell.setUp(with: NSLocalizedString("please_wait", comment: "Loading message for rules"), useArrow: false)
        }

        return cell
    }

    /// When a row is tapped
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Get the selected rule
        guard let selectedRule = RuleController.shared.allRules?[safe: indexPath.row] else { return }
        guard let index = selectedRule.index, let url = selectedRule.url else { return CrashlyticsHelper.recordUnexpectedNil("index or url") }

        // Start the loading icon (after a slight delay to avoid flashing it for very fast loads)
        perform(#selector(startLoadingIcon), with: nil, afterDelay: 0.1)

        // Load the data
        RuleController.shared.fetchRule(withIndex: index, andURL: url, completion: handleCompletion(with: { [weak self] (rule: Rule?) in
            // Cancel the request to start the loading icon if it hasn't already been started
            if let self = self { NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.startLoadingIcon), object: nil) }

            // Go to the next page to display the selected rule
            self?.coordinator?.goTo(DetailViewController()) { $0.rule = rule }
        }))
    }
}
