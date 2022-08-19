//
//  BaseViewController.swift
//
//  Created by Shannon Draeker on 10/22/20.
//

import UIKit

class BaseViewController: UIViewController {
    // MARK: - Properties

    weak var coordinator: Coordinator?

    // MARK: - View Lifecycle

    override func loadView() {
        super.loadView()

        // Set up the default UI
        view.backgroundColor = .background
        addAllSubviews()
        setUpConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Listen for notifications in changes to internet access
        handleReachabilityUpdate()
        NotificationHelper.observe(.reachabilityChanged, #selector(handleReachabilityUpdate), self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Stop listening for the notifications when the view is no longer active
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: nil)
    }

    // MARK: - Set Up UI

    /// Add these functions here, to be overridden in each specific view controller
    func addAllSubviews() {}
    func setUpConstraints() {}

    /// Make the status bar light
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    /// Set up the nav bar with a title
    func setUpNavBar(withTitle title: String) {
        // Set the title
        let titleView = UILabel(title, color: .text, fontSize: 24, fontName: .bold, alignment: .center)
        navigationItem.titleView = titleView

        // Remove the back text
        navigationItem.backButtonTitle = ""

        // Color the navigation bar
        navigationController?.navigationBar.barTintColor = .darkHighlight
        navigationController?.navigationBar.tintColor = .text

        // Fix for iOS 15's breaking of the nav bar color
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithDefaultBackground()
            appearance.backgroundColor = .darkHighlight
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        }

        // Show the navigation bar
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    // MARK: - Internet

    /// Handle changes in internet access
    @objc func handleReachabilityUpdate() {
        // If there's no internet, show the no internet view
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if !Reachability().isReachable { self.coordinator?.showModally(NoInternetViewController(), from: self) }
        }
    }
}

// MARK: - Error Handling

extension UIViewController {
    /// Print, log, and display an error
    func record(_ error: Error, _ file: String = #fileID, _ function: String = #function, _ line: Int = #line) {
        // Print, log, and display the error
        CrashlyticsHelper.record(error, file, function, line)
        presentErrorAlert(error)
    }

    /// A default function for handling a generic result completion
    func handleCompletion(showAlert: Bool = true, _ file: String = #fileID, _ function: String = #function, _ line: Int = #line, with successCompletion: ((Bool) -> Void)? = nil, _ errorCompletion: ((CustomError) -> Void)? = nil) -> ResultCompletion {
        return { [weak self] result in
            DispatchQueue.main.async {
                self?.view.stopLoadingIcon()

                switch result {
                case let .success(success):
                    successCompletion?(success)
                case let .failure(error):
                    errorCompletion?(error)

                    // Show the alert only if the parameter is true and the view is visible
                    let isVisible = (self?.viewIfLoaded?.window != nil)
                    if showAlert, isVisible {
                        self?.record(error, file, function, line)
                    } else {
                        CrashlyticsHelper.record(error, file, function, line)
                    }
                }
            }
        }
    }

    /// A default function for handling a generic result completion with an object
    func handleCompletion<T>(showAlert: Bool = true, _ file: String = #fileID, _ function: String = #function, _ line: Int = #line, with successCompletion: ((T) -> Void)? = nil, _ errorCompletion: ((CustomError) -> Void)? = nil) -> ResultCompletionWith<T> {
        return { [weak self] result in
            DispatchQueue.main.async {
                self?.view.stopLoadingIcon()

                switch result {
                case let .success(object):
                    successCompletion?(object)
                case let .failure(error):
                    errorCompletion?(error)

                    // Show the alert only if the parameter is true and the view is visible
                    let isVisible = (self?.viewIfLoaded?.window != nil)
                    if showAlert, isVisible {
                        self?.record(error, file, function, line)
                    } else {
                        CrashlyticsHelper.record(error, file, function, line)
                    }
                }
            }
        }
    }
}
