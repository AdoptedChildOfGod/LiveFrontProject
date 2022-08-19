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

    /// Add an image before or after the text of a label and set the text of the label to the resulting attributed string
    /// - Parameters:
    ///   - image: The image to add, or nil
    ///   - afterLabel: Whether the put the image before or after the text
    func addImage(image: UIImage?, afterLabel: Bool = false) {
        guard let image = image else { return }
        let attachment = NSTextAttachment()
        attachment.image = image
        attachment.bounds = CGRect(x: 0, y: 0,
                                   width: intrinsicContentSize.height / 2.4,
                                   height: intrinsicContentSize.height / 2.8)
        let attachmentString = NSAttributedString(attachment: attachment)

        let startingText = text ?? ""

        if afterLabel {
            let strLabelText = NSMutableAttributedString(string: "\(startingText) ")
            strLabelText.append(attachmentString)

            attributedText = strLabelText
        } else {
            let strLabelText = NSAttributedString(string: " \(startingText)")
            let mutableAttachmentString = NSMutableAttributedString(attributedString: attachmentString)
            mutableAttachmentString.append(strLabelText)
            attributedText = mutableAttachmentString
        }
    }

    /// Add an image to an attributed string, and return the result as an attributed string
    /// - Parameters:
    ///   - image: The image to add, or nil
    ///   - text: The text to add it to
    ///   - afterLabel: Whether the put the image before or after the text
    /// - Returns: The combined image and text as an attributed string
    func addImageToText(image: UIImage?, text: NSMutableAttributedString, afterLabel: Bool = false) -> NSMutableAttributedString {
        let attachment = NSTextAttachment()
        attachment.image = image
        attachment.bounds = CGRect(x: 0, y: 0,
                                   width: intrinsicContentSize.height / 2.4,
                                   height: intrinsicContentSize.height / 2.8)
        let attachmentString = NSAttributedString(attachment: attachment)
        let strLabelText = text

        if afterLabel {
            strLabelText.append(attachmentString)
            return strLabelText
        } else {
            let mutableAttachmentString = NSMutableAttributedString(attributedString: attachmentString)
            mutableAttachmentString.append(strLabelText)

            return mutableAttachmentString
        }
    }

    /// Add spacing between the letters of a word
    /// - Parameter kernValue: The spacing between the letters (default 1.2)
    func addCharacterSpacing(_ kernValue: Double = 1.2) {
        if let labelText = text, !labelText.isEmpty {
            let attributedString = NSMutableAttributedString(string: labelText)
            attributedString.addAttribute(NSAttributedString.Key.kern, value: kernValue,
                                          range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
        }
    }

    /// Change the font size
    /// - Parameter fontSize: Size of the new font, leaving the font family the same
    func changeFontSize(to fontSize: CGFloat) {
        font = UIFont(name: font.familyName, size: fontSize)
    }

    /// Decrease the font size by a given amount
    /// - Parameter increment: The increment by which to decrease the font (default 0.5)
    func decreaseFontSize(by increment: CGFloat = 0.5) {
        changeFontSize(to: font.pointSize - increment)
    }
}
