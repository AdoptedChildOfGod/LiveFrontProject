//
//  LoadingIcon.swift
//  TheWay
//
//  Created by Shannon Draeker on 10/22/20.
//

import UIKit.UIView

extension UIView {
    /// Dim the screen and show a loading icon in a rounded darker opaque square in the center of the screen
    func startLoadingIcon() {
        // Put a transparent view over everything to dim the screen
        let backgroundView = UIView(color: .black, alpha: 0.4, tag: 475_647)

        // Create a darker rounded square in the middle of the screen
        let squareView = UIView(color: .black, alpha: 0.6, cornerRadius: 18, tag: 475_648)

        // Format the loading icon and place it in the center of the square
        let activityIndicator = UIActivityIndicatorView(frame: backgroundView.frame)
        activityIndicator.center = backgroundView.center
        activityIndicator.hidesWhenStopped = true
        if #available(iOS 13.0, *) { activityIndicator.style = .large }
        activityIndicator.color = .white
        activityIndicator.startAnimating()

        // Don't allow the user to interact with the screen while it's loading
        isUserInteractionEnabled = false

        // Add the views to display the loading icon
        backgroundView.addSubviews(squareView, activityIndicator)
        addSubview(backgroundView)
        backgroundView.anchorFill(self)
        squareView.anchor([.centerX, .centerY], to: backgroundView).anchor(aspectRatio: 1, size: 90)
        activityIndicator.anchor([.centerX, .centerY], to: backgroundView)
    }

    /// Remove the loading icon from the screen
    func stopLoadingIcon() {
        // Remove the views from the screen
        if let backgroundView = viewWithTag(475_647) {
            if let squareView = backgroundView.viewWithTag(475_648) { squareView.removeFromSuperview() }
            backgroundView.removeFromSuperview()
        }
        // Allow the user to interact with the screen again
        isUserInteractionEnabled = true
    }
}
