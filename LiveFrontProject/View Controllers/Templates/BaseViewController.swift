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
        //        view.backgroundColor = .background
        view.backgroundColor = .white
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

// MARK: - Helper Methods

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
                        self?.showToast(message: error.localizedDescription)
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
                        self?.showToast(message: error.localizedDescription)
                        CrashlyticsHelper.record(error, file, function, line)
                    }
                }
            }
        }
    }
}
