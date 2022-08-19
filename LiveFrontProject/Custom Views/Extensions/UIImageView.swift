//
//  UIImageView.swift
//
//  Created by Shannon Draeker on 10/22/20.
//

import UIKit.UIImageView

extension UIImageView {
    /// A way to initialize an image view while setting up the most important properties at the same time
    /// - Parameters:
    ///   - image: The image to use
    ///   - tintColor: The color to tint the image, useful for coloring logos or icons (default nil)
    ///   - contentMode: The content mode of the image (ie, .center, .scaleAspectFill, etc) (default .scaleAspectFill)
    ///   - tag: The optional tag for the view
    convenience init(_ image: UIImage?, tintColor: UIColor? = nil, contentMode: ContentMode = .scaleAspectFill, tag: Int? = nil) {
        self.init()

        // Set the image, with the tint color if applicable
        if #available(iOS 13.0, *), let tintColor = tintColor {
            self.image = image?.withTintColor(tintColor)
        } else {
            self.image = image
        }

        // Set the content mode
        self.contentMode = contentMode

        // Set the tag
        if let tag = tag { self.tag = tag }
    }

    /// Set the color of the image contained in the image view
    func setImageTintColor(_ color: UIColor) {
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        image = tintedImage
        tintColor = color
    }
}
