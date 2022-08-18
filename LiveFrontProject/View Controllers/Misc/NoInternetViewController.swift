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

        addAllSubviews()
        setUpConstraints()

        // Listen for notifications in changes to internet access
        NotificationHelper.observe(.reachabilityChanged, #selector(handleReachabilityUpdate), self)
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
        // Dismiss the view if and only if there's now internet
        DispatchQueue.main.async { [weak self] in if Reachability().isReachable { self?.closeModal() } }
    }

    // MARK: - UI Elements

    /// The main stack view containing everything else
    private let mainStackView = UIStackView(axis: .vertical, alignment: .center, distribution: .fill, spacing: 30)
    /// The icon
    private let noInternetImageView = UIImageView(.noWifi.withTintColor(.midGray))
    /// The label
    private let noInternetLabel = UILabel(.noInternetMessage, alignment: .center, autoResize: false)
    /// The refresh button
    private let refreshButton = UIButton("", image: .refresh, action: #selector(refreshButtonTapped))

    // MARK: - Set Up UI

    /// Add all the subviews to the view
    private func addAllSubviews() {
        mainStackView.addArrangedSubviews(noInternetImageView, noInternetLabel, refreshButton)
        view.addSubview(mainStackView)
    }

    /// Set up the constraints and lay out all the elements in the view
    private func setUpConstraints() {
        // The main stack view containing everything else
        mainStackView.anchorCenterY(to: view, nil, offset: 60).anchorCenterX(to: view).setCustomSpacing(12, after: noInternetImageView)

        // The icon
        noInternetImageView.anchor(aspectRatio: 1, size: 200)

        // The refresh button
        refreshButton.anchor(aspectRatio: 1, size: 32)
    }
}
