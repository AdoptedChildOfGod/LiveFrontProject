//
//  UITextField.swift
//
//  Created by Shannon Draeker on 10/22/20.
//

import UIKit.UITextField

extension UITextField {
    /// A way to initialize a textfield while setting up the most important properties at the same time
    /// - Parameters:
    ///   - text: The text (default nil)
    ///   - placeholder: The placeholder
    ///   - placeholderColor: The color of the placeholder text (default .gray)
    ///   - textColor: The color of the text (default .white)
    ///   - fontSize: The font size (default 18)
    ///   - fontName: The font to use, defined by the enum FontNames (default .regular)
    ///   - type: The type of keyboard to use (default .default)
    ///   - autoCorrect: Whether or not to use autocorrect (default false)
    ///   - autoCapitalization: What type of autocapitalization to use (default .none)
    ///   - returnKey: What the return key of the keyboard should say (default .next)
    ///   - isPassword: If true, the textfield will obscure the input with dots as with passwords (default false)
    ///   - tag: The tag (default 0)
    convenience init(text: String? = nil,
                     placeholder: String,
                     placeholderColor: UIColor = .gray,
                     textColor: UIColor = .white,
                     fontSize: CGFloat = 18,
                     fontName: FontNames = .regular,
                     type: UIKeyboardType = .default,
                     autoCorrect: Bool = false,
                     autoCapitalization: UITextAutocapitalizationType = .none,
                     returnKey: UIReturnKeyType = .next,
                     isPassword: Bool = false,
                     tag: Int = 0) {
        self.init()
        self.text = text
        setUpViews(placeholder: placeholder, placeholderColor: placeholderColor, textColor: textColor, fontSize: fontSize, fontName: fontName, type: type, autoCorrect: autoCorrect, autoCapitalization: autoCapitalization, returnKey: returnKey, isPassword: isPassword)
        self.tag = tag
    }

    /// A helper function to format the most common properties of a button
    /// - Parameters:
    ///   - placeholder: The placeholder
    ///   - placeholderColor: The color of the placeholder text (default .gray)
    ///   - textColor: The color of the text (default .white)
    ///   - fontSize: The font size (default 18)
    ///   - fontName: The font to use, defined by the enum FontNames (default .regular)
    ///   - type: The type of keyboard to use (default .default)
    ///   - autoCorrect: Whether or not to use autocorrect (default false)
    ///   - autoCapitalization: What type of autocapitalization to use (default .none)
    ///   - returnKey: What the return key of the keyboard should say (default .next)
    ///   - isPassword: If true, the textfield will obscure the input with dots as with passwords (default false)
    func setUpViews(placeholder: String,
                    placeholderColor: UIColor,
                    textColor: UIColor = .white,
                    fontSize: CGFloat = 18,
                    fontName: FontNames = .regular,
                    type: UIKeyboardType = .default,
                    autoCorrect: Bool = false,
                    autoCapitalization: UITextAutocapitalizationType = .none,
                    returnKey: UIReturnKeyType = .next,
                    isPassword: Bool = false) {
        // Set the placeholder
        setPlaceholder(placeholder, color: placeholderColor)

        // Set the colors and font
        backgroundColor = .clear
        self.textColor = textColor
        if let customFont = UIFont(name: fontName.rawValue, size: fontSize) {
            font = customFont
        } else {
            font = UIFont(name: FontNames.regular.rawValue, size: fontSize)
            CrashlyticsHelper.recordUnexpectedNil("customFont")
        }

        // Set the type and options of the keyboard
        keyboardType = type
        autocorrectionType = autoCorrect ? .yes : .no
        autocapitalizationType = autoCapitalization
        returnKeyType = returnKey
        isSecureTextEntry = isPassword

        // Center the content vertically
        contentVerticalAlignment = .center

        // Automatically resize the text as necessary
        adjustsFontSizeToFitWidth = true
    }

    /// Set the placeholder text of the textfield
    /// - Parameters:
    ///   - text: The text of the placeholder
    ///   - color: The color of the placeholder
    func setPlaceholder(_ text: String, color: UIColor) {
        attributedPlaceholder = NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor: color])
    }
}
