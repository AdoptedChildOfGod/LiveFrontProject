//
//  SimpleTableViewCell.swift
//  LiveFrontProject
//
//  Created by Shannon Draeker on 8/19/22.
//

import UIKit.UITableViewCell

/// A simple tableview cell that mimics the default one but with better customization
class SimpleTableViewCell: UITableViewCell {
    // MARK: - Initializer

    func setUp(with title: String, useArrow: Bool = true) {
        // Format the cell
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none

        // Set up the UI
        addAllSubviews()
        setUpConstraints()
        titleLabel.text = title
        disclosureIndicatorView.setVisible(if: useArrow)
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        // Reset the view to avoid adding additional or duplicate constraints
        [contentView, mainStackView].forEach { $0.removeAllConstraints() }
        [contentView, mainStackView].forEach { $0.removeAllSubviews() }
    }

    // MARK: - UI Elements

    /// The stack view
    private let mainStackView = UIStackView(axis: .horizontal, alignment: .fill, distribution: .equalSpacing)

    /// The title and disclosure indicator
    private let titleLabel = UILabel("", numberOfLines: 1)
    private let disclosureIndicatorView = UIImageView(UIImage(systemName: "chevron.right"), contentMode: .scaleAspectFit)

    // MARK: - Set Up UI

    /// Add all the subviews to the view
    private func addAllSubviews() {
        mainStackView.addArrangedSubviews(titleLabel, disclosureIndicatorView)
        contentView.addSubview(mainStackView)
    }

    /// Set up the constraints and lay out all the elements in the view
    private func setUpConstraints() {
        // The stack view
        mainStackView.anchorCenterY(to: contentView, 0.5).anchor([.leading, .trailing], to: contentView, padding: [12, 4])

        // The title and disclosure indicator
        disclosureIndicatorView.anchor(aspectRatio: 1, size: 24)
        disclosureIndicatorView.setImageTintColor(.text)
    }
}
