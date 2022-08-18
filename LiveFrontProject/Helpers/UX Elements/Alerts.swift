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
    ///   - icon: The icon of the alert (optional, default nil)
    ///   - title: The title of the alert
    ///   - message: The body of the alert (optional, if nil will be hidden)
    ///   - dismissButtonText: The text of the button that dismisses the alert (default "Dismiss")
    ///   - completion: An optional completion to run after the dismiss button is clicked
    func presentAlert(icon: AlertIcons? = nil,
                      title: String,
                      message: String?,
                      dismissButtonText: String = .ok,
                      completion: @escaping () -> Void = {}) {
        // Create and display the custom alert
        let customAlert = CustomAlertController(icon: icon,
                                                title: title,
                                                message: message,
                                                dismissText: dismissButtonText,
                                                dismissCompletion: completion)
        present(customAlert, animated: true)
    }

    /// Present an alert that the internet connection isn't working
    func presentInternetAlert() {
        presentAlert(icon: .warning, title: .noInternet, message: .noInternetFull)
    }

    /// Present an alert with a message and confirm/cancel buttons
    /// - Parameters:
    ///   - icon: The icon of the alert (optional, default nil)
    ///   - title: The title of the alert
    ///   - message: The body of the alert (optional, if nil will be hidden)
    ///   - cancelText: The text of the cancel button that dismisses the alert (default "Cancel")
    ///   - confirmText: The text of the confirm button that executes some action (default "Confirm")
    ///   - completion: The completion to run after the confirm button is clicked
    func presentChoiceAlert(icon: AlertIcons? = nil,
                            title: String,
                            message: String?,
                            cancelText: String = .cancel,
                            confirmText: String = .confirm,
                            completion: @escaping () -> Void,
                            secondConfirmText: String? = nil,
                            secondCompletion: @escaping () -> Void = {}) {
        // Create and display the custom alert
        let customAlert = CustomAlertController(icon: icon,
                                                title: title,
                                                message: message,
                                                dismissText: cancelText,
                                                confirmText: confirmText,
                                                confirmCompletion: completion,
                                                secondConfirmText: secondConfirmText,
                                                secondConfirmCompletion: secondCompletion)
        present(customAlert, animated: true)
    }

    /// Present an alert with a title, message, and an arbitrary number of buttons
    /// - Parameters:
    ///   - icon: The icon of the alert (optional, default nil)
    ///   - title: The title of the alert
    ///   - message: The body of the alert (optional, if nil will be hidden)
    ///   - buttons: An array of buttons, each with a name, completion, and color
    func presentManyChoicesAlert(icon: AlertIcons? = nil,
                                 title: String,
                                 message: String?,
                                 buttons: [ButtonInfo]) {
        // Create and display the custom alert
        let customAlert = CustomAlertController(icon: icon, title: title, message: message, buttons: buttons)
        present(customAlert, animated: true)
    }

    /// Present an alert with a message, text field, and save/cancel buttons
    /// - Parameters:
    ///   - icon: The icon of the alert  (optional, default nil)
    ///   - title: The title of the alert
    ///   - message: The body of the alert (optional, if nil will be hidden)
    ///   - textFieldPlaceholder: The placeholder text to display in the textfield of the alert
    ///   - textFieldText: The text to display in the textfield (for example, if editing an existing string, you could populate it in the textfield here) (default nil)
    ///   - saveButtonTitle: The text of the save button that executes some action (default "Save")
    ///   - completion: The completion to run after the save button is clicked
    func presentTextFieldAlert(icon: AlertIcons? = nil,
                               title: String,
                               message: String?,
                               textFieldPlaceholder: String?,
                               textFieldText: String? = nil,
                               saveButtonTitle: String = .save,
                               completion: @escaping (String) -> Void) {
        // Create and display the custom alert
        let customAlert = CustomAlertController(icon: icon,
                                                title: title,
                                                message: message,
                                                dismissText: .cancel,
                                                confirmText: saveButtonTitle,
                                                textFieldPlaceholder: textFieldPlaceholder,
                                                textFieldText: textFieldText,
                                                textCompletion: completion)
        present(customAlert, animated: true)
    }

    /// Present an alert to display an error
    func presentErrorAlert(_ localizedError: LocalizedError, _ completion: @escaping () -> Void = {}) {
        presentAlert(icon: .error, title: .error, message: localizedError.errorDescription ?? "", dismissButtonText: .ok, completion: completion)
    }

    func presentErrorAlert(_ error: Error, _ completion: @escaping () -> Void = {}) {
        presentAlert(icon: .error, title: .error, message: error.localizedDescription, dismissButtonText: .ok, completion: completion)
    }

    /// Dismiss any alert when the user taps outside of it
    @objc func dismissAlert() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Custom Alert Controller

class CustomAlertController: KeyboardViewController {
    // MARK: - Properties

    /// The optional completion for when the dismiss button is tapped
    private var dismissCompletion: () -> Void = {}

    /// The optional completion for when the confirm button is tapped on the regular confirm button
    private var confirmCompletion: () -> Void = {}

    /// The optional completion for when the confirm button is tapped on the confirm button for an optional, second choice
    private var secondConfirmCompletion: () -> Void = {}
    private var usingSecondOption = false

    /// The optional completion for when the confirm button is tapped on a text field alert
    private var textCompletion: (String) -> Void = { _ in }

    /// The actions for if there are many buttons
    private var buttonCompletions: [() -> Void]?

    // MARK: - Initializer

    /// Initialize a simple alert, text field alert, or choice alert
    convenience init(icon: AlertIcons?,
                     title: String,
                     message: String?,
                     dismissText: String,
                     dismissCompletion: @escaping () -> Void = {},
                     confirmText: String? = nil,
                     confirmCompletion: @escaping () -> Void = {},
                     secondConfirmText: String? = nil,
                     secondConfirmCompletion: @escaping () -> Void = {},
                     textFieldPlaceholder: String? = nil,
                     textFieldText: String? = nil,
                     textCompletion: @escaping (String) -> Void = { _ in }) {
        self.init()

        self.dismissCompletion = dismissCompletion
        self.confirmCompletion = confirmCompletion
        self.secondConfirmCompletion = secondConfirmCompletion
        usingSecondOption = secondConfirmText != nil
        self.textCompletion = textCompletion

        // Set the presentation style to mimic a native alert
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve

        // Set the values of the UI
        iconImageView.image = icon?.icon
        iconImageView.isHidden = (icon == nil)
        titleLabel.text = title
        messageLabel.text = message
        messageLabel.isHidden = (message == nil)
        dismissButton.setTitle(dismissText, for: .normal)
        confirmButton.setTitle(confirmText, for: .normal)
        confirmButton.isHidden = (confirmText == nil)
        confirmButtonsStackView.isHidden = (confirmText == nil)
        secondConfirmButton.setTitle(secondConfirmText, for: .normal)
        secondConfirmButton.isHidden = (secondConfirmText == nil)
        dismissButton.backgroundColor = (confirmText == nil) ? .blueAccent : .redAccent.withAlphaComponent(0.7)

        // Set up the text field, if applicable
        if let textFieldPlaceholder = textFieldPlaceholder {
            textField.text = textFieldText
            textField.setPlaceholder(textFieldPlaceholder, color: .midGray)
        } else {
            textField.isHidden = true
        }
    }

    /// Initialize an alert with many button options
    convenience init(icon: AlertIcons?,
                     title: String,
                     message: String?,
                     buttons: [ButtonInfo]) {
        self.init()

        usingSecondOption = false
        buttonCompletions = buttons.map(\.action)

        // Set the presentation style to mimic a native alert
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve

        // Set the values of the UI
        iconImageView.image = icon?.icon
        iconImageView.isHidden = (icon == nil)
        titleLabel.text = title
        messageLabel.text = message
        messageLabel.isHidden = (message == nil)
        dismissButton.isHidden = true
        confirmButton.isHidden = true
        confirmButtonsStackView.isHidden = true
        textField.isHidden = true
        buttonsStackView.axis = .vertical
        buttonsStackView.spacing = 8

        // Programmatically add each of the many buttons
        for (index, buttonInfo) in buttons.enumerated() {
            let button = BlueButton(title: buttonInfo.name, action: #selector(genericButtonTapped(_:)))
            button.tag = index
            button.backgroundColor = buttonInfo.color
            button.anchor(height: 50)
            buttonsStackView.addArrangedSubviews(button)
        }
    }

    // MARK: - View Lifecycle

    override func loadView() {
        super.loadView()
        view.backgroundColor = .almostBlack.withAlphaComponent(0.6)

        addAllSubviews()
        setUpConstraints()
    }

    // MARK: - Actions

    /// Dismiss the alert
    @objc private func dismissAlertView() {
        // If the keyboard is open and the user clicked outside of the text field, simply close the keyboard and don't do anything else
        if keyboardIsOpen { return closeKeyboard() }

        // Otherwise, dismiss the alert
        dismiss(animated: true, completion: dismissCompletion)
    }

    /// Execute the confirm action and dismiss the alert
    @objc private func confirmButtonTapped() {
        dismiss(animated: true) { [weak self] in
            self?.textCompletion(self?.textField.text ?? "")
            self?.confirmCompletion()
        }
    }

    /// Execute the optional second confirm action and dismiss the alert
    @objc private func secondConfirmButtonTapped() {
        dismiss(animated: true) { [weak self] in self?.secondConfirmCompletion() }
    }

    /// The action for when one of the "many options" button is tapped
    @objc private func genericButtonTapped(_ sender: UIButton) {
        guard let completion = buttonCompletions?[safe: sender.tag] else { return }
        dismiss(animated: true) { completion() }
    }

    // MARK: - Keyboard Methods

    override func gestureRecognizer(_ gesture: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let view = touch.view, view.isKind(of: UIButton.self) { return true }
        return false
    }

    /// The done key on the keyboard should have the same effect as clicking the confirm button on the alert
    override func doneKeyPressed() {
        confirmButtonTapped()
    }

    override func adjustUIForNoKeyboard() {
        alertBodyView.getConstraint(for: .bottom, ofType: .lessThan, withTag: "-keyboard")?.constant = 0
    }

    override func adjustUIForKeyboard(ofSize size: CGRect?) {
        alertBodyView.getConstraint(for: .bottom, ofType: .lessThan, withTag: "-keyboard")?.constant = -((size?.height ?? 0) + 20)
    }

    // MARK: - UI Elements

    /// The background view that the user can tap on to dismiss the alert
    private let backgroundView = UIView()
    /// The container that forms the body of the alert
    private let alertBodyView = UIView(color: .white)
    /// The stack view containing everything
    private let mainStackView = UIStackView(axis: .vertical, alignment: .center, distribution: .fill, spacing: 20)
    /// The icon, title, and message
    private let iconImageView = UIImageView(nil, contentMode: .scaleAspectFit)
    private let titleLabel = UILabel("", fontSize: 18, fontName: .medium, alignment: .center)
    private let messageLabel = UILabel("", color: .gray, fontSize: 14, alignment: .center)
    /// The optional text field
    private let textField = PlainTextField(text: nil, placeholder: "", returnKey: .done)
    override var keyboardViews: [UIView] { [textField] }
    /// The button(s)
    private let buttonsStackView = UIStackView(axis: .horizontal, alignment: .fill, distribution: .fillEqually, spacing: 16)
    private let dismissButton = BlueButton(title: .dismiss, action: #selector(dismissAlertView))
    private let confirmButtonsStackView = UIStackView(axis: .horizontal, alignment: .fill, distribution: .fillEqually, spacing: 16)
    private let confirmButton = BlueButton(title: .confirm, action: #selector(confirmButtonTapped))
    private let secondConfirmButton = BlueButton(title: .confirm, action: #selector(secondConfirmButtonTapped))

    // MARK: - Set Up UI

    /// Add all the subviews to the view
    private func addAllSubviews() {
        confirmButtonsStackView.addArrangedSubviews(confirmButton, secondConfirmButton)
        if usingSecondOption {
            buttonsStackView.axis = .vertical
            buttonsStackView.addArrangedSubviews(confirmButtonsStackView, dismissButton)
        } else {
            buttonsStackView.addArrangedSubviews(dismissButton, confirmButtonsStackView)
        }
        mainStackView.addArrangedSubviews(iconImageView, titleLabel, messageLabel, textField, buttonsStackView)

        alertBodyView.addSubview(mainStackView)
        view.addSubviews(backgroundView, alertBodyView)
    }

    /// Set up the constraints and lay out all the elements in the view
    private func setUpConstraints() {
        // The background view that the user can tap on to dismiss the alert
        backgroundView.anchorFill(view).backgroundColor = .clear
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissAlertView)))

        // The container that forms the body of the alert
        alertBodyView.anchor([.bottom, .centerY], to: view, types: [.lessThan], tags: ["-keyboard"]).anchorCenterX(to: view, 0.85).addCornerRadius(16)
        alertBodyView.getConstraint(for: .centerY)?.priority = .defaultLow

        // The stack view containing everything
        mainStackView.anchor([.top, .bottom], to: alertBodyView, padding: [20, -20]).anchorCenterX(to: alertBodyView)
        mainStackView.setCustomSpacings([8, 22], after: [titleLabel, messageLabel])

        // The icon, title, and message
        iconImageView.anchor(aspectRatio: 1, size: 42)

        // The optional text field
        textField.anchorCenterX(to: alertBodyView).anchor(height: 50)
        textField.textColor = .almostBlack
        textField.backgroundColor = .offWhite

        // The button(s)
        buttonsStackView.anchorCenterX(to: alertBodyView)
        [dismissButton, confirmButton, secondConfirmButton].forEach { $0.anchor(height: 50) }
    }
}

enum AlertIcons {
    case success
    case warning
    case error
    case other(UIImage)

    var icon: UIImage {
        switch self {
        case .success: return .success
        case .warning: return .warning
        case .error: return .error
        case let .other(image): return image
        }
    }
}

struct ButtonInfo {
    var name: String
    var action: () -> Void
    var color: UIColor
}
