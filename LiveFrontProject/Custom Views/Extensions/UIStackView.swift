//
//  UIStackView.swift
//
//  Created by Shannon Draeker on 10/22/20.
//

import UIKit.UIStackView

extension UIStackView {
    /// A way to initialize a stack view while setting up the most important properties at the same time
    /// - Parameters:
    ///   - axis: The axis, horizontal or vertical
    ///   - alignment: The alignment of the stack view (ie, .fill, .center, etc)
    ///   - distribution: The distribution of the stack view (ie, .fill, .fillEqually, etc)
    ///   - spacing: The spacing of the stack view (optional, default nil)
    convenience init(axis: NSLayoutConstraint.Axis, alignment: UIStackView.Alignment, distribution: UIStackView.Distribution, spacing: CGFloat? = nil) {
        self.init()

        self.axis = axis
        self.alignment = alignment
        self.distribution = distribution
        if let spacing = spacing { self.spacing = spacing }
    }

    /// Add multiple subviews to a stack view at once
    /// - Parameter views: Any view to add to the stack view, in the order they should appear
    @discardableResult
    func addArrangedSubviews(_ views: UIView...) -> Self {
        views.forEach { addArrangedSubview($0) }
        return self
    }

    /// Add multiple subviews to a stack view at once
    /// - Parameter views: Any view to add to the stack view, in the order they should appear
    @discardableResult
    func addArrangedSubviews(_ views: [UIView]) -> Self {
        views.forEach { addArrangedSubview($0) }
        return self
    }

    /// Set multiple custom spacings at a time
    func setCustomSpacings(_ spacings: [CGFloat], after views: [UIView]) {
        for (index, spacing) in spacings.enumerated() {
            if let view = views[safe: index] {
                setCustomSpacing(spacing, after: view)
            }
        }
    }

    /// Add a background view to the stack view to give it a background color
    func addBackground(color: UIColor) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
    }
}
