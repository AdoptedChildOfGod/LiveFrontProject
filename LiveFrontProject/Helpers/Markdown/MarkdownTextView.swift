//
//  MarkdownTextView.swift
//  EyeQ
//
//  Created by Shannon Draeker on 4/28/22.
//

import UIKit.UITextView

/// The markdown renders best in a textview, but we don't want all the behavior of a text view so this is a customized text view used specifically for displaying markdown text throughout the app
class MarkdownTextView: UITextView {
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)

        isScrollEnabled = false
        isEditable = false
        isUserInteractionEnabled = true
        backgroundColor = .clear
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
