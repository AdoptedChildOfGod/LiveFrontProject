//
//  UILabel.swift
//
//  Created by Shannon Draeker on 10/22/20.
//

import UIKit.UILabel

extension UILabel {
    /// A way to initialize a label while setting up the most important properties at the same time
    /// - Parameters:
    ///   - text: The text of the label
    ///   - color: The color of the text (default white)
    ///   - fontSize: The font size (default 18)
    ///   - fontName: The font to use, defined by the enum FontNames (default .regular)
    ///   - alignment: The text alignment (default left)
    ///   - autoResize: Whether the font size automatically resizes if the label gets too small (default true)
    ///   - numberOfLines: The number of lines the label is allowed to take (default 0)
    convenience init(_ text: String?,
                     color: UIColor = .text,
                     fontSize: CGFloat = 18,
                     fontName: FontNames = .regular,
                     alignment: NSTextAlignment = .left,
                     autoResize: Bool = true,
                     numberOfLines: Int = 0) {
        self.init()
        setUpViews(text, color: color, fontSize: fontSize, fontName: fontName, alignment: alignment, autoResize: autoResize, numberOfLines: numberOfLines)
    }

    /// A helper function to format the most common properties of a label
    /// - Parameters:
    ///   - text: The text of the label
    ///   - color: The color of the text (default white)
    ///   - fontSize: The font size (default 18)
    ///   - fontName: The font to use, defined by the enum FontNames (default .regular)
    ///   - alignment: The text alignment (default left)
    ///   - automaticResizing: Whether the font size automatically resizes if the label gets too small (default true)
    ///   - numberOfLines: The number of lines the label is allowed to take (default 0)
    ///   - autoResize: Whether the font size automatically resizes if the label gets too small (default true)
    func setUpViews(_ text: String?,
                    color: UIColor = .text,
                    fontSize: CGFloat = 18,
                    fontName: FontNames = .regular,
                    alignment: NSTextAlignment = .left,
                    autoResize: Bool = true,
                    numberOfLines: Int = 0) {
        self.text = text

        // Color
        textColor = color

        // Font
        if let customFont = UIFont(name: fontName.rawValue, size: fontSize) {
            font = customFont
        } else { font = UIFont(name: font.familyName, size: fontSize) }

        // Alignment
        textAlignment = alignment
        self.numberOfLines = numberOfLines

        // Automatically resize as necessary
        adjustsFontSizeToFitWidth = autoResize
    }
}
