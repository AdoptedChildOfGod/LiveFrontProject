//
//  Alerts.swift
//  TheWay
//
//  Created by Shannon Draeker on 10/22/20.
//

import UIKit.UIViewController

extension UIViewController {
    /// Present a simple alert with a message and a single button to dismiss the alert
    /// - Parameters:
    ///   - title: The title of the alert
    ///   - message: The body of the alert
    ///   - dismissButtonText: The text of the button that dismisses the alert (default "Dismiss")
    ///   - completion: An optional completion to run after the dismiss button is clicked
    func presentAlert(title: String, message: String, dismissButtonText: String = "Dismiss", completion: @escaping () -> Void = {}) {
        // Create the alert controller
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        // Add the dismiss button to the alert
        alertController.addAction(UIAlertAction(title: dismissButtonText, style: .default, handler: { _ in completion() }))

        // Present the alert
        present(alertController, animated: true) {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissAlert))
            alertController.view.superview?.subviews[0].addGestureRecognizer(tapGesture)
        }
    }

    /// Present an alert to display an error
    func presentErrorAlert(_ localizedError: LocalizedError) {
        // Create the alert controller
        let alertController = UIAlertController(title: "ERROR", message: localizedError.errorDescription, preferredStyle: .alert)

        // Add the dismiss button to the alert
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel))

        // Present the alert
        present(alertController, animated: true) {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissAlert))
            alertController.view.superview?.subviews[0].addGestureRecognizer(tapGesture)
        }
    }

    /// Present an alert to display an error
    func presentErrorAlert(_ error: Error) {
        // Create the alert controller
        let alertController = UIAlertController(title: "ERROR", message: error.localizedDescription, preferredStyle: .alert)

        // Add the dismiss button to the alert
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel))

        // Present the alert
        present(alertController, animated: true) {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissAlert))
            alertController.view.superview?.subviews[0].addGestureRecognizer(tapGesture)
        }
    }

    /// Dismiss any alert when the user taps outside of it
    @objc func dismissAlert() {
        dismiss(animated: true, completion: nil)
    }
}
