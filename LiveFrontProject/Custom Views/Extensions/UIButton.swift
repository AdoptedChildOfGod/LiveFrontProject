//
//  UIButton.swift
//
//  Created by Shannon Draeker on 10/22/20.
//

import UIKit.UIButton

extension UIButton {
    /// A way to initialize a button while setting up the most important properties at the same time
    /// - Parameters:
    ///   - title: The title of the button
    ///   - titleColor: The color of the button's title (default white)
    ///   - image: The image to use for the button (optional, default nil)
    ///   - background: The background color of the label (default clear)
    ///   - fontSize: The font size (default 18)
    ///   - fontName: The font to use, defined by the enum FontNames (default .regular)
    ///   - cornerRadius: The corner radius (default 6)
    ///   - borderColor: The color of the border (default nil)
    ///   - borderSize: The size of the border (default 0)
    ///   - padding: The padding from the button text to the edges of the background, in the order of [top, left, bottom, right] (default nil)
    ///   - alignmentX: The horizontal alignment of the text (default center)
    ///   - alignmentY: The vertical alignment of the text (default center)
    ///   - autoResize: Whether or not to automatically resize the text of the button if it becomes to small (default false)
    ///   - tag: The tag for the button (optional, default nil)
    ///   - target: The target for the button (defaults the view where the button is declared)
    ///   - action: The action for the button (the function that will be called when the button is tapped)
    convenience init(_ title: String,
                     titleColor: UIColor = .white,
                     image: UIImage? = nil,
                     background: UIColor = .clear,
                     fontSize: CGFloat = 18,
                     fontName: FontNames = .regular,
                     cornerRadius: CGFloat = 6,
                     borderColor: UIColor? = nil,
                     borderSize: CGFloat = 0,
                     padding: [CGFloat]? = nil,
                     alignmentX: UIControl.ContentHorizontalAlignment = .center,
                     alignmentY: UIControl.ContentVerticalAlignment = .center,
                     autoResize: Bool = false,
                     tag: Int? = nil,
                     target: Any? = self,
                     action: Selector? = nil) {
        self.init()
        setUpViews(title, titleColor: titleColor, image: image, background: background, fontSize: fontSize, fontName: fontName, cornerRadius: cornerRadius, borderColor: borderColor, borderSize: borderSize, padding: padding, alignmentX: alignmentX, alignmentY: alignmentY, autoResize: autoResize)
        if let tag = tag { self.tag = tag }
        if let action = action { addTarget(target, action: action, for: .touchUpInside) }
    }

    /// A helper function to format the most common properties of a button
    /// - Parameters:
    ///   - title: The title of the button
    ///   - titleColor: The color of the button's title (default white)
    ///   - image: The image to use for the button (optional, default nil)
    ///   - background: The background color of the label (default clear)
    ///   - fontSize: The font size (default 18)
    ///   - fontName: The font to use, defined by the enum FontNames (default .regular)
    ///   - cornerRadius: The corner radius (default 6)
    ///   - borderColor: The color of the border (default nil)
    ///   - borderSize: The size of the border (default 0)
    ///   - padding: The padding from the button text to the edges of the background, in the order of [top, left, bottom, right] (default nil)
    ///   - alignmentX: The horizontal alignment of the text (default center)
    ///   - alignmentY: The vertical alignment of the text (default center)
    ///   - autoResize: Whether or not to automatically resize the text of the button if it becomes to small (default false)
    func setUpViews(_ title: String,
                    titleColor: UIColor = .white,
                    image: UIImage? = nil,
                    background: UIColor = .clear,
                    fontSize: CGFloat = 18,
                    fontName: FontNames = .regular,
                    cornerRadius: CGFloat = 6,
                    borderColor: UIColor? = nil,
                    borderSize: CGFloat = 0,
                    padding: [CGFloat]? = nil,
                    alignmentX: UIControl.ContentHorizontalAlignment = .center,
                    alignmentY: UIControl.ContentVerticalAlignment = .center,
                    autoResize: Bool = false) {
        // The title
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)

        // The image
        if let image = image { setImage(image, for: .normal) }

        // The font
        if let customFont = UIFont(name: fontName.rawValue, size: fontSize) {
            titleLabel?.font = customFont
        } else { titleLabel?.font = UIFont(name: titleLabel!.font!.familyName, size: fontSize) }
        self.autoResize = autoResize

        // The background
        backgroundColor = background

        // Round the corners
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true

        // The border
        if let borderColor = borderColor {
            layer.borderColor = borderColor.cgColor
            layer.borderWidth = borderSize
        }

        // The alignment
        contentHorizontalAlignment = alignmentX
        contentVerticalAlignment = alignmentY

        // Add padding
        if let padding = padding {
            var configuration = UIButton.Configuration.filled()
            configuration.title = title
            configuration.image = image
            configuration.contentInsets = NSDirectionalEdgeInsets(top: padding[0], leading: padding[1], bottom: padding[2], trailing: padding[3])
        }
    }

    /// Autoresize the title of the button as the button size changes, imitating the way the adjustFontSizeToFitWidth parameter of a label works
    var autoResize: Bool {
        get {
            titleLabel?.adjustsFontSizeToFitWidth ?? false
        }
        set {
            titleLabel?.numberOfLines = 1
            titleLabel?.adjustsFontSizeToFitWidth = newValue
            titleLabel?.lineBreakMode = .byClipping
            titleLabel?.baselineAdjustment = .alignCenters
        }
    }

    /// Change the font size
    /// - Parameter fontSize: The new font size
    func changeFontSize(to fontSize: CGFloat) {
        guard let font = titleLabel?.font else { return }
        titleLabel?.font = UIFont(name: font.familyName, size: fontSize)
    }

    /// Decrease the font size by a given amount
    /// - Parameter increment: The increment by which to decrease the font (default 0.5)
    func decreaseFontSize(by increment: CGFloat = 0.5) {
        guard let font = titleLabel?.font else { return }
        changeFontSize(to: font.pointSize - increment)
    }
}
