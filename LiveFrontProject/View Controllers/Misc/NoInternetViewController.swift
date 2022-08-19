//
//  NoInternetViewController.swift
//
//  Created by Shannon Draeker on 2/15/22.
//

import UIKit

class NoInternetViewController: BaseViewController {
    // MARK: - View Lifecycle

    override func loadView() {
        super.loadView()
        CrashlyticsHelper.log()
    }

    // MARK: - Actions

    /// Check to see if the internet connection is back
    @objc private func refreshButtonTapped() {
        // Spin the button so that the user knows something is happening
        refreshButton.rotate360Degrees(duration: 0.4)

        // Check to see if there's an update in internet status
        handleReachabilityUpdate()
    }

    // MARK: - Helper Methods

    /// Handle changes in internet access
    @objc override func handleReachabilityUpdate() {
        // Dismiss the view if and only if there's currently internet
        DispatchQueue.main.async { [weak self] in if Reachability().isReachable { self?.dismiss(animated: true) } }
    }

    // MARK: - UI Elements

    /// The main stack view containing everything else
    private let mainStackView = UIStackView(axis: .vertical, alignment: .center, distribution: .fill, spacing: 30)
    /// The icon
    private let noInternetImageView = UIImageView(.noWifi.withTintColor(.text.withAlphaComponent(0.5)))
    /// The label
    private let noInternetLabel = UILabel(NSLocalizedString("no_internet", comment: "No internet connection message"), alignment: .center, autoResize: false)
    /// The refresh button
    private let refreshButton = UIButton("", image: .refresh.withTintColor(.text), action: #selector(refreshButtonTapped))

    // MARK: - Set Up UI

    /// Add all the subviews to the view
    override func addAllSubviews() {
        mainStackView.addArrangedSubviews(noInternetImageView, noInternetLabel, refreshButton)
        view.addSubview(mainStackView)
    }

    /// Set up the constraints and lay out all the elements in the view
    override func setUpConstraints() {
        // The main stack view containing everything else
        mainStackView.anchorCenterY(to: view, nil, offset: 60).anchorCenterX(to: view).setCustomSpacing(12, after: noInternetImageView)

        // The icon
        noInternetImageView.anchor(aspectRatio: 1, size: 200)

        // The refresh button
        refreshButton.anchor(aspectRatio: 1, size: 32)
    }
}
