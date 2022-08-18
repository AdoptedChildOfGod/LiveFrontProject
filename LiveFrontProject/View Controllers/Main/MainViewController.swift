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

        addAllSubviews()
        setUpConstraints()
    }

    // MARK: - UI Elements

    // MARK: - Set Up UI

    /// Add all the subviews to the view
    private func addAllSubviews() {}

    /// Set up the constraints and lay out all the elements in the view
    private func setUpConstraints() {}
}
