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
        CrashlyticsHelper.log("Rule index: \(rule?.index ?? "ERROR")")

        // Show the navigation bar with the rule name
        setUpNavBar(withTitle: rule?.name ?? NSLocalizedString("error", comment: "Error"))

        // Set the content label if there are no subsections
        // TODO: - somehow test this...?
        if rule?.subsections?.isEmpty ?? true, let markdownText = rule?.desc {
            contentLabel.attributedText = SwiftyMarkdown(string: markdownText, maxImageWidth: view.width * 0.9).applyDefaultFormatting(color: .text).attributedString()
        }

        // Show either the subsections or the content label
        contentContainerView.setVisible(if: rule?.subsections?.isEmpty ?? true)
        subsectionsTableView.setVisible(if: rule?.subsections?.isEmpty == false)
    }

    // MARK: - Actions

    /// Start the loading icon (written inside a selector for more control over timing)
    @objc private func startLoadingIcon() {
        DispatchQueue.main.async { [weak self] in self?.view.startLoadingIcon() }
    }

    // MARK: - UI Elements

    /// The label with the content of the rule, if applicable
    private let contentContainerView = UIScrollView()
    private lazy var contentLabel = MarkdownTextView(frame: .zero, textContainer: nil)

    /// The tableview listing the subsections, if applicable
    private lazy var subsectionsTableView = UITableView(delegate: self, dataSource: self, cellClass: SimpleTableViewCell.self, separator: .singleLine)

    // MARK: - Set Up UI

    /// Add all the subviews to the view
    override func addAllSubviews() {
        contentContainerView.addSubview(contentLabel)

        view.addSubviews(contentContainerView, subsectionsTableView)
    }

    /// Set up the constraints and lay out all the elements in the view
    override func setUpConstraints() {
        // The label with the content of the rule, if applicable
        contentContainerView.anchorFill(view, safeArea: true)
        contentLabel.anchor([.top, .bottom], to: contentContainerView, padding: [10, 10]).anchorCenterX(to: contentContainerView)

        // The tableview listing the subsections, if applicable
        subsectionsTableView.anchorTop(to: view, 4, safeArea: true).anchorBottom(to: view, 10, safeArea: true).anchorCenterX(to: view, 1)
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
            cell.setUp(with: NSLocalizedString("error_try_again", comment: "Error message"), useArrow: false)
        }

        return cell
    }

    /// When a row is tapped
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Get the selected rule
        guard let selectedSubsection = rule?.subsections?[safe: indexPath.row] else { return }
        guard let index = selectedSubsection.index, let url = selectedSubsection.url else { return CrashlyticsHelper.recordUnexpectedNil("index or url") }

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
