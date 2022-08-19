//
//  DetailViewController.swift
//  LiveFrontProject
//
//  Created by Shannon Draeker on 8/19/22.
//

import UIKit

class DetailViewController: BaseViewController {
    // MARK: - Properties

    /// The rule to display
    var rule: Rule?

    // MARK: - View Lifecycle

    override func loadView() {
        super.loadView()
        CrashlyticsHelper.log()

        // Show the navigation bar
        setUpNavBar(withTitle: rule?.name ?? .error)
    }

    // MARK: - UI Elements

    /// The tableview listing the subsections, if applicable
    private lazy var subsectionsTableView = UITableView(delegate: self, dataSource: self, cellClass: SimpleTableViewCell.self, separator: .singleLine)

    // MARK: - Set Up UI

    /// Add all the subviews to the view
    override func addAllSubviews() {
        view.addSubviews(subsectionsTableView)
    }

    /// Set up the constraints and lay out all the elements in the view
    override func setUpConstraints() {
        // The tableview listing all the top level rules
//        subsectionsTableView.anchorBelow(titleBackgroundView, 4).anchorBottom(to: view, 10, safeArea: true).anchorCenterX(to: view, 1)
        subsectionsTableView.separatorColor = .highlight
    }
}

// MARK: - TableView Methods

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    /// The number of rows
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int { rule?.subsections?.count ?? 0 }

    /// The content of each row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SimpleTableViewCell.identifier, for: indexPath) as? SimpleTableViewCell else { return UITableViewCell() }

        // Fill in the text of the cell with the subsections
        if let subsectionName = rule?.subsections?[safe: indexPath.row]?.name {
            cell.setUp(with: subsectionName)
        } else {
            cell.setUp(with: "There was an error - please try again", useArrow: false)
        }

        return cell
    }

    /// When a row is tapped
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Get the selected rule
        guard let selectedSubsection = rule?.subsections?[safe: indexPath.row] else { return }

        // Go the next page
    }
}
