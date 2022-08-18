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

    /// Present an alert with a message and confirm/cancel buttons
    /// - Parameters:
    ///   - title: The title of the alert
    ///   - message: The body of the alert
    ///   - cancelText: The text of the cancel button that dismisses the alert (default "Cancel")
    ///   - confirmText: The text of the confirm button that executes some action (default "Confirm")
    ///   - completion: The completion to run after the confirm button is clicked
    func presentChoiceAlert(title: String, message: String, cancelText: String = "Cancel", confirmText: String = "Confirm", completion: @escaping () -> Void) {
        // Create the alert controller
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        // Add the cancel button to the alert
        alertController.addAction(UIAlertAction(title: cancelText, style: .cancel))

        // Add the confirm button to the alert
        alertController.addAction(UIAlertAction(title: confirmText, style: .default, handler: { _ in completion() }))

        // Present the alert
        present(alertController, animated: true) {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissAlert))
            alertController.view.superview?.subviews[0].addGestureRecognizer(tapGesture)
        }
    }

    /// Present an alert with a message, text field, and save/cancel buttons
    /// - Parameters:
    ///   - title: The title of the alert
    ///   - message: The body of the alert
    ///   - textFieldPlaceholder: The placeholder text to display in the textfield of the alert
    ///   - textFieldText: The text to display in the textfield (for example, if editing an existing string, you could populate it in the textfield here) (default nil)
    ///   - saveButtonTitle: The text of the save button that executes some action (default "Save")
    ///   - completion: The completion to run after the save button is clicked
    func presentTextFieldAlert(title: String, message: String, textFieldPlaceholder: String?, textFieldText: String? = nil, saveButtonTitle: String = "Save", completion: @escaping (String) -> Void) {
        // Create the alert controller
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        // Add the text field
        alertController.addTextField { textField in
            textField.placeholder = textFieldPlaceholder
            if let textFieldText = textFieldText {
                textField.text = textFieldText
            }
        }

        // Create the cancel button
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        // Create the save button
        let saveAction = UIAlertAction(title: saveButtonTitle, style: .default) { _ in
            // Get the text from the text field
            guard let text = alertController.textFields?.first?.text, !text.isEmpty else { return }

            // Run the desired completion function with the text input
            completion(text)
        }

        // Add the buttons to the alert and present it
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
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
