//
//  SwiftyMarkdown+Defaults.swift
//  EyeQ
//
//  Created by Shannon Draeker on 4/28/22.
//

import UIKit

/// Apply the default formatting used in all the markdown throughout the app
extension SwiftyMarkdown {
    func applyDefaultFormatting(color: UIColor = .text) -> Self {
        h1.fontName = FontNames.bold.rawValue
        h1.fontSize = 24
        h1.fontStyle = .bold
        h1.color = color

        h2.fontName = FontNames.bold.rawValue
        h2.fontSize = 22
        h2.fontStyle = .bold
        h2.color = color

        h3.fontName = FontNames.bold.rawValue
        h3.fontSize = 20
        h3.fontStyle = .bold
        h3.color = color

        h4.fontName = FontNames.boldItalic.rawValue
        h4.fontSize = 18
        h4.fontStyle = .bold
        h4.color = color

        h5.fontName = FontNames.boldItalic.rawValue
        h5.fontSize = 18
        h5.fontStyle = .bold
        h5.color = color

        h6.fontName = FontNames.boldItalic.rawValue
        h6.fontSize = 16
        h6.fontStyle = .normal
        h6.color = color

        body.fontName = FontNames.regular.rawValue
        body.fontSize = 16
        body.fontStyle = .normal
        body.color = color

        blockquotes.fontName = FontNames.regular.rawValue
        blockquotes.fontSize = 16
        blockquotes.fontStyle = .italic
        blockquotes.color = color

        link.fontName = FontNames.regular.rawValue
        link.fontSize = 16
        link.color = .systemBlue
        underlineLinks = true

        bold.fontName = FontNames.bold.rawValue
        bold.fontSize = 16
        bold.color = color

        italic.fontName = FontNames.regular.rawValue
        italic.fontSize = 16
        italic.color = color

        code.fontSize = 16
        code.color = .lightGray

        strikethrough.fontName = FontNames.regular.rawValue
        strikethrough.fontSize = 16
        strikethrough.color = color

        return self
    }
}
