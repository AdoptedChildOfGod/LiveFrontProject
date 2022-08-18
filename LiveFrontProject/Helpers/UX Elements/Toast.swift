//
//  Toast.swift
//  TheWay
//
//  Created by Shannon Draeker on 10/22/20.
//

import UIKit.UIViewController

extension UIViewController {
    /// How long to display the toast message
    enum ToastDuration: Double {
        case short = 2.0
        case medium = 4.0
        case long = 6.0
    }

    /// Display a message on the screen that automatically disappears after a few seconds, similar to Android's toast functionality
    /// - Parameters:
    ///   - message: The text to display
    ///   - duration: Short (2 seconds), medium (4 seconds), or long (6 seconds) (default short)
    func showToast(message: String, duration: ToastDuration = .short) {
        // Get the window in order to display the toast above any views below it
        let window = UIApplication.shared.connectedScenes
            // Keep only active scenes, onscreen and visible to the user
            .filter { $0.activationState == .foregroundActive }
            // Keep only the first `UIWindowScene`
            .first(where: { $0 is UIWindowScene })
            // Get its associated windows
            .flatMap { $0 as? UIWindowScene }?.windows
            // Finally, keep only the key window
            .first(where: \.isKeyWindow)

        // Remove the previous toast first, if applicable
        if let backgroundView = window?.viewWithTag(65194) { backgroundView.removeFromSuperview() }

        // Create the text of the toast
        let toastLabel = UILabel(message, color: .white, fontSize: 18, alignment: .center)
        toastLabel.adjustsFontSizeToFitWidth = true

        // Create the background
        let backgroundView = UIView(color: .black, alpha: 0.5, cornerRadius: 12, tag: 65194)
        let width = min(toastLabel.intrinsicContentSize.width / 0.8, 150)
        let height = min(max(toastLabel.intrinsicContentSize.height / 0.8, 40), 80)
        backgroundView.frame = CGRect(x: (view.frame.size.width - width) / 2,
                                      y: view.frame.size.height - 100,
                                      width: width, height: height)

        // Add the text to the background
        backgroundView.addSubview(toastLabel)
        toastLabel.anchor([.centerX, .centerY, .width, .height], to: backgroundView, widthMultiplier: 0.8, heightMultiplier: 0.8)

        // Display the toast message
        window?.addSubview(backgroundView)
        UIView.animate(withDuration: 0.5, delay: duration.rawValue, options: .curveEaseOut, animations: {
            backgroundView.alpha = 0
            toastLabel.alpha = 0
        }, completion: { _ in
            backgroundView.removeFromSuperview()
        })
    }
}
