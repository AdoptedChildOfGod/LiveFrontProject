//
//  UIView.swift
//
//  Created by Shannon Draeker on 10/22/20.
//

import UIKit.UIView

// MARK: - Initializer

extension UIView {
    /// A way to initialize a view while setting up the most important properties at the same time
    /// - Parameters:
    ///   - color: The background color of the view
    ///   - alpha: The alpha of the background color (default 1)
    ///   - cornerRadius: The corner radius of the view (default nil)
    ///   - tag: The tag of the view (default nil)
    convenience init(color: UIColor, alpha: CGFloat = 1, cornerRadius: CGFloat? = nil, tag: Int? = nil) {
        self.init()
        setUpViews(color: color, alpha: alpha, cornerRadius: cornerRadius)
        if let tag = tag { self.tag = tag }
    }

    /// A helper function to format the most common properties of a view
    /// - Parameters:
    ///   - color: The background color of the view
    ///   - alpha: The alpha of the background color (default 1)
    ///   - cornerRadius: The corner radius of the view (default nil)
    func setUpViews(color: UIColor, alpha: CGFloat = 1, cornerRadius: CGFloat? = nil) {
        // The background color
        backgroundColor = color.withAlphaComponent(alpha)

        // Round the corners
        if let cornerRadius = cornerRadius {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = true
        }
    }

    /// Returns a string representation of this class.
    var identifier: String { String(describing: type(of: self)) }
    class var identifier: String { String(describing: type(of: self)) }
}

// MARK: - Helper Methods

extension UIView {
    /// Add a border around the view
    func addBorder(color: UIColor, width: CGFloat) {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }

    /// Add a corner radius to a view
    func addCornerRadius(_ radius: CGFloat) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }

    /// Add a shadow to a view even if the view has rounded corners
    func addShadow(with radius: CGFloat = 6) {
        clipsToBounds = true
        layer.masksToBounds = false
        layer.shadowRadius = radius
        layer.shadowOpacity = 0.6
        layer.shadowOffset = CGSize(width: 2, height: 3)
        layer.shadowColor = UIColor.black.cgColor
        layer.shouldRasterize = true
    }

    /// Quickly add button-like functionality to any view
    func addInteraction(target: Any?, action: Selector) {
        isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: target, action: action))
    }
}

// MARK: - Frame Helper

/// Make it extremely easy to get or set any of the frame properties of a view
extension UIView {
    /// Get or set frame.origin.x
    var x: CGFloat {
        get { frame.origin.x }
        set { frame = CGRect(x: newValue, y: y, width: width, height: height) }
    }

    /// Get or set frame.origin.y
    var y: CGFloat {
        get { frame.origin.y }
        set { frame = CGRect(x: x, y: newValue, width: width, height: height) }
    }

    /// Get or set frame.size.width
    var width: CGFloat {
        get { frame.size.width }
        set { frame = CGRect(x: x, y: y, width: newValue, height: height) }
    }

    /// Get or set frame.size.height
    var height: CGFloat {
        get { frame.height }
        set { frame = CGRect(x: x, y: y, width: width, height: newValue) }
    }
}

// MARK: - Gradient

extension UIView {
    /// Create a left to right gradient effect
    /// - Parameter colors: An array of the colors the use in the gradient
    func applyGradientLeftRight(with colors: [UIColor]) {
        layer.insertSublayer(createGradient(colors: colors, direction: .leftToRight), at: 0)
    }

    /// Create a top to bottom gradient effect
    /// - Parameter colors: An array of the colors the use in the gradient
    func applyGradientTopBottom(with colors: [UIColor]) {
        layer.insertSublayer(createGradient(colors: colors, direction: .topToBottom), at: 0)
    }

    /// Apply a gradient to a view with the colors and direction specified
    /// - Parameters:
    ///   - colors: An array of the colors the use in the gradient
    ///   - direction: The direction of the gradient
    /// - Returns: A gradient layer that can be added to any view via self.layer.insertSublayer()
    func createGradient(colors: [UIColor], direction: GradientDirection) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = colors.map { $0.cgColor }
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = direction.startPoint
        gradient.endPoint = direction.endPoint
        gradient.name = "gradientLayer"
        return gradient
    }

    /// The directions a gradient can go
    enum GradientDirection {
        case topToBottom
        case leftToRight
        case bottomToTop
        case rightToLeft

        var startPoint: CGPoint {
            switch self {
            case .topToBottom:
                return CGPoint(x: 0.0, y: 0.0)
            case .leftToRight:
                return CGPoint(x: 0.0, y: 0.5)
            case .bottomToTop:
                return CGPoint(x: 0.0, y: 1.0)
            case .rightToLeft:
                return CGPoint(x: 1.0, y: 0.5)
            }
        }

        var endPoint: CGPoint {
            switch self {
            case .topToBottom:
                return CGPoint(x: 0.0, y: 1.0)
            case .leftToRight:
                return CGPoint(x: 1.0, y: 0.5)
            case .bottomToTop:
                return CGPoint(x: 0.0, y: 0.0)
            case .rightToLeft:
                return CGPoint(x: 0.0, y: 0.5)
            }
        }
    }
}

// MARK: - Animations

extension UIView {
    /// Cause the view to shake
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: center.x - 10, y: center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: center.x + 10, y: center.y))
        layer.add(animation, forKey: "position")
    }

    /// Spin a view around in a full circle
    func rotate360Degrees(duration: CFTimeInterval = 1) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(Double.pi * 2)
        rotateAnimation.isRemovedOnCompletion = false
        rotateAnimation.duration = duration
        rotateAnimation.repeatCount = 1
        layer.add(rotateAnimation, forKey: nil)
    }
}

// MARK: - Misc

extension UIView {
    /// Get the frame of a subview relative to the current view
    func getConvertedFrame(fromSubview subview: UIView) -> CGRect? {
        guard subview.isDescendant(of: self) else { return nil }

        var frame = subview.frame
        if subview.superview == nil { return frame }

        var superview = subview.superview
        while superview != self {
            frame = superview!.convert(frame, to: superview!.superview)
            if superview?.superview == nil {
                break
            } else {
                superview = superview!.superview
            }
        }

        return superview!.convert(frame, to: self)
    }

    /// Set isHidden to true
    @discardableResult
    func hide() -> Self {
        isHidden = true
        return self
    }

    /// Set isHidden to false
    @discardableResult
    func show() -> Self {
        isHidden = false
        return self
    }

    /// Set isHidden based on some variable
    @discardableResult
    func setVisible(if shouldBeVisible: Bool) -> Self {
        isHidden = !shouldBeVisible
        return self
    }
}

// MARK: - Anchoring Constraints

extension UIView {
    /// Add multiple subviews at once
    @discardableResult
    func addSubviews(_ views: UIView...) -> Self {
        views.forEach(addSubview(_:))
        return self
    }

    /// Remove all the subviews from the  view
    func removeAllSubviews() {
        subviews.forEach { $0.removeFromSuperview() }
    }

    /// Remove all the constraints from the view
    func removeAllConstraints() {
        constraints.forEach { removeConstraint($0) }
    }

    /// Fetch and return a specific constraint
    func getConstraint(for side: ConstraintSide, ofType type: ConstraintType = .equal, withTag tag: String = "") -> NSLayoutConstraint? {
        if let constraint = superview?.constraints.first(where: { $0.identifier == "\(side.rawValue)-\(type)\(tag)" }) {
            return constraint
        }
        return constraints.first(where: { $0.identifier == "\(side.rawValue)-\(type)\(tag)" })
    }

    /// The types of constraints possible to anchor
    enum ConstraintSide: String {
        case top
        case bottom
        case leading
        case trailing
        case centerX
        case centerY
        case width
        case height
    }

    /// The types of constraints possible to anchor
    enum ConstraintType {
        case equal
        case greaterThan
        case lessThan
    }

    /// Anchor the specified constraints to the given view
    @discardableResult
    func anchor(_ constraints: [ConstraintSide], to otherView: UIView, padding: [CGFloat]? = nil, types: [ConstraintType]? = nil, safeArea: [Bool]? = nil, tags: [String]? = nil, widthMultiplier: CGFloat? = nil, heightMultiplier: CGFloat? = nil) -> Self {
        for i in 0 ..< constraints.count {
            let constraintType = constraints[i]
            switch constraintType {
            case .top:
                anchor(top: (safeArea?[safe: i] == true) ? otherView.safeAreaLayoutGuide.topAnchor : otherView.topAnchor,
                       paddingTop: padding?[safe: i] ?? 0,
                       topType: types?[safe: i] ?? .equal,
                       topTag: tags?[safe: i] ?? "")
            case .bottom:
                anchor(bottom: (safeArea?[safe: i] == true) ? otherView.safeAreaLayoutGuide.bottomAnchor : otherView.bottomAnchor,
                       paddingBottom: padding?[safe: i] ?? 0,
                       bottomType: types?[safe: i] ?? .equal,
                       bottomTag: tags?[safe: i] ?? "")
            case .leading:
                anchor(leading: (safeArea?[safe: i] == true) ? otherView.safeAreaLayoutGuide.leadingAnchor : otherView.leadingAnchor,
                       paddingLeading: padding?[safe: i] ?? 0,
                       leadingType: types?[safe: i] ?? .equal,
                       leadingTag: tags?[safe: i] ?? "")
            case .trailing:
                anchor(trailing: (safeArea?[safe: i] == true) ? otherView.safeAreaLayoutGuide.trailingAnchor : otherView.trailingAnchor,
                       paddingTrailing: padding?[safe: i] ?? 0,
                       trailingType: types?[safe: i] ?? .equal,
                       trailingTag: tags?[safe: i] ?? "")
            case .centerX:
                anchor(centerX: otherView)
            case .centerY:
                anchor(centerY: otherView)
            case .width:
                anchor(width: (safeArea?[safe: i] == true) ? otherView.safeAreaLayoutGuide.widthAnchor : otherView.widthAnchor,
                       widthMultiplier: widthMultiplier ?? 1)
            case .height:
                anchor(height: (safeArea?[safe: i] == true) ? otherView.safeAreaLayoutGuide.heightAnchor : otherView.heightAnchor,
                       heightMultiplier: heightMultiplier ?? 1)
            }
        }

        return self
    }

    /// Set constraints for the top, bottom, or sides of a view, or set the width or height to constant values
    @discardableResult
    func anchor(top: NSLayoutYAxisAnchor? = nil, topView: UIView? = nil, paddingTop: CGFloat = 0, topType: ConstraintType = .equal, topTag: String = "",
                bottom: NSLayoutYAxisAnchor? = nil, bottomView: UIView? = nil, paddingBottom: CGFloat = 0, bottomType: ConstraintType = .equal, bottomTag: String = "",
                leading: NSLayoutXAxisAnchor? = nil, leadingView: UIView? = nil, paddingLeading: CGFloat = 0, leadingType: ConstraintType = .equal, leadingTag: String = "",
                trailing: NSLayoutXAxisAnchor? = nil, trailingView: UIView? = nil, paddingTrailing: CGFloat = 0, trailingType: ConstraintType = .equal, trailingTag: String = "",
                width: CGFloat? = nil, widthType: ConstraintType = .equal, widthTag: String = "",
                height: CGFloat? = nil, heightType: ConstraintType = .equal, heightTag: String = "") -> Self {
        translatesAutoresizingMaskIntoConstraints = false

        // Set the top constraint if it's specified
        if top != nil || topView != nil {
            var constraint: NSLayoutConstraint?

            switch topType {
            case .equal:
                constraint = topAnchor.constraint(equalTo: top ?? topView!.topAnchor, constant: paddingTop)
            case .greaterThan:
                constraint = topAnchor.constraint(greaterThanOrEqualTo: top ?? topView!.topAnchor, constant: paddingTop)
            case .lessThan:
                constraint = topAnchor.constraint(lessThanOrEqualTo: top ?? topView!.topAnchor, constant: paddingTop)
            }

            constraint?.identifier = "\(ConstraintSide.top.rawValue)-\(topType)\(topTag)"
            constraint?.isActive = true
        }

        // Set the bottom constraint if it's specified
        if bottom != nil || bottomView != nil {
            var constraint: NSLayoutConstraint?
            switch bottomType {
            case .equal:
                constraint = bottomAnchor.constraint(equalTo: bottom ?? bottomView!.bottomAnchor, constant: paddingBottom)
            case .greaterThan:
                constraint = bottomAnchor.constraint(greaterThanOrEqualTo: bottom ?? bottomView!.bottomAnchor, constant: paddingBottom)
            case .lessThan:
                constraint = bottomAnchor.constraint(lessThanOrEqualTo: bottom ?? bottomView!.bottomAnchor, constant: paddingBottom)
            }

            constraint?.identifier = "\(ConstraintSide.bottom.rawValue)-\(bottomType)\(bottomTag)"
            constraint?.isActive = true
        }

        // Set the leading constraint if it's specified
        if leading != nil || leadingView != nil {
            var constraint: NSLayoutConstraint?

            switch leadingType {
            case .equal:
                constraint = leadingAnchor.constraint(equalTo: leading ?? leadingView!.leadingAnchor, constant: paddingLeading)
            case .greaterThan:
                constraint = leadingAnchor.constraint(greaterThanOrEqualTo: leading ?? leadingView!.leadingAnchor, constant: paddingLeading)
            case .lessThan:
                constraint = leadingAnchor.constraint(lessThanOrEqualTo: leading ?? leadingView!.leadingAnchor, constant: paddingLeading)
            }

            constraint?.identifier = "\(ConstraintSide.leading.rawValue)-\(leadingType)\(leadingTag)"
            constraint?.isActive = true
        }

        // Set the trailing constraint if it's specified
        if trailing != nil || trailingView != nil {
            var constraint: NSLayoutConstraint?

            switch trailingType {
            case .equal:
                constraint = trailingAnchor.constraint(equalTo: trailing ?? trailingView!.trailingAnchor, constant: -paddingTrailing)
            case .greaterThan:
                constraint = trailingAnchor.constraint(greaterThanOrEqualTo: trailing ?? trailingView!.trailingAnchor, constant: -paddingTrailing)
            case .lessThan:
                constraint = trailingAnchor.constraint(lessThanOrEqualTo: trailing ?? trailingView!.trailingAnchor, constant: -paddingTrailing)
            }

            constraint?.identifier = "\(ConstraintSide.trailing.rawValue)-\(trailingType)\(trailingTag)"
            constraint?.isActive = true
        }

        // Set the width constraint if it's specified
        if let width = width {
            var constraint: NSLayoutConstraint?

            switch widthType {
            case .equal:
                constraint = widthAnchor.constraint(equalToConstant: width)
            case .greaterThan:
                constraint = widthAnchor.constraint(greaterThanOrEqualToConstant: width)
            case .lessThan:
                constraint = widthAnchor.constraint(lessThanOrEqualToConstant: width)
            }

            constraint?.identifier = "\(ConstraintSide.width.rawValue)-\(widthType)\(widthTag)"
            constraint?.isActive = true
        }

        // Set the height constraint if it's specified
        if let height = height {
            var constraint: NSLayoutConstraint?

            switch heightType {
            case .equal:
                constraint = heightAnchor.constraint(equalToConstant: height)
            case .greaterThan:
                constraint = heightAnchor.constraint(greaterThanOrEqualToConstant: height)
            case .lessThan:
                constraint = heightAnchor.constraint(lessThanOrEqualToConstant: height)
            }

            constraint?.identifier = "\(ConstraintSide.height.rawValue)-\(heightType)\(heightTag)"
            constraint?.isActive = true
        }

        return self
    }

    /// Anchor the center of a view or set the width or height to proportional values
    @discardableResult
    func anchor(centerX: UIView? = nil, centerY: UIView? = nil, centerYOffset: CGFloat = 0,
                width: NSLayoutDimension? = nil, widthView: UIView? = nil, widthMultiplier: CGFloat = 1,
                height: NSLayoutDimension? = nil, heightView: UIView? = nil, heightMultiplier: CGFloat = 1) -> Self {
        translatesAutoresizingMaskIntoConstraints = false

        if let centerX = centerX {
            let constraint = centerXAnchor.constraint(equalTo: centerX.centerXAnchor)
            constraint.identifier = "\(ConstraintSide.centerX.rawValue)-\(ConstraintType.equal)"
            constraint.isActive = true
        }
        if let centerY = centerY {
            let constraint = centerYAnchor.constraint(equalTo: centerY.centerYAnchor, constant: centerYOffset)
            constraint.identifier = "\(ConstraintSide.centerY.rawValue)-\(ConstraintType.equal)"
            constraint.isActive = true
        }

        if width != nil || widthView != nil {
            let constraint = widthAnchor.constraint(equalTo: width ?? widthView!.widthAnchor, multiplier: widthMultiplier)
            constraint.identifier = "\(ConstraintSide.width.rawValue)-\(ConstraintType.equal)"
            constraint.isActive = true
        }

        if height != nil || heightView != nil {
            let constraint = heightAnchor.constraint(equalTo: height ?? heightView!.heightAnchor, multiplier: heightMultiplier)
            constraint.identifier = "\(ConstraintSide.height.rawValue)-\(ConstraintType.equal)"
            constraint.isActive = true
        }

        return self
    }

    /// A shortcut to center a view horizontally in another view
    @discardableResult
    func anchorCenterX(to otherView: UIView, _ multiplier: CGFloat = 0.9) -> Self {
        return anchor(centerX: otherView, widthView: otherView, widthMultiplier: multiplier)
    }

    /// A shortcut to center a view vertically in another view
    /// - Parameters:
    ///   - otherView: The view to vertically center this view in
    ///   - multiplier: Optional - pass in a number between 0 and 1 if you want this view to take up a percentage of the other view, and pass in nil if you want to simply center it and let this view set its own height. Defaults to 0.9 (90%)
    ///   - offset: Optional - vertically center this view in the other view and offset it from center (positive values lift the view higher than center). Defaults to 0 (centered)
    @discardableResult
    func anchorCenterY(to otherView: UIView, _ multiplier: CGFloat? = 0.9, offset: CGFloat = 0) -> Self {
        return anchor(centerY: otherView, centerYOffset: -offset, heightView: (multiplier != nil) ? otherView : nil, heightMultiplier: multiplier ?? 0)
    }

    /// A shortcut to place one view to the top of another
    @discardableResult
    func anchorTop(to otherView: UIView, _ padding: CGFloat = 0, safeArea: Bool = false) -> Self {
        return anchor(top: safeArea ? otherView.safeAreaLayoutGuide.topAnchor : otherView.topAnchor, paddingTop: padding)
    }

    /// A shortcut to place one view to the bottom of another
    @discardableResult
    func anchorBottom(to otherView: UIView, _ padding: CGFloat = 0, safeArea: Bool = false) -> Self {
        return anchor(bottom: safeArea ? otherView.safeAreaLayoutGuide.bottomAnchor : otherView.bottomAnchor, paddingBottom: -padding)
    }

    /// A shortcut to place one view below another
    @discardableResult
    func anchorBelow(_ otherView: UIView, _ padding: CGFloat = 0) -> Self {
        return anchor(top: otherView.bottomAnchor, paddingTop: padding)
    }

    /// A shortcut to place one view above another
    @discardableResult
    func anchorAbove(_ otherView: UIView, _ padding: CGFloat = 0) -> Self {
        return anchor(bottom: otherView.topAnchor, paddingBottom: padding)
    }

    /// A shortcut to place one view to the right of another
    @discardableResult
    func anchorRight(of otherView: UIView, _ padding: CGFloat = 0) -> Self {
        return anchor(leading: otherView.trailingAnchor, paddingLeading: padding)
    }

    /// A shortcut to place one view to the right of another
    @discardableResult
    func anchorLeft(of otherView: UIView, _ padding: CGFloat = 0) -> Self {
        return anchor(trailing: otherView.leadingAnchor, paddingTrailing: padding)
    }

    /// A shortcut to anchor the height of one view as a percentage of another
    @discardableResult
    func anchorHeight(to otherView: UIView, percent: CGFloat) -> Self {
        return anchor(height: otherView.heightAnchor, heightMultiplier: percent)
    }

    /// A shortcut to anchor one view to fill another
    @discardableResult
    func anchorFill(_ otherView: UIView, safeArea: Bool = false, paddingTop: CGFloat = 0, paddingBottom: CGFloat = 0, paddingLeading: CGFloat = 0, paddingTrailing: CGFloat = 0) -> Self {
        return anchor([.top, .bottom, .leading, .trailing], to: otherView, padding: [paddingTop, paddingBottom, paddingLeading, paddingTrailing], safeArea: [safeArea, safeArea])
    }

    /// Anchor a view to a certain aspect ratio (ratios greater than 1 make the view longer vertically, and the size is the width)
    @discardableResult
    func anchor(aspectRatio: CGFloat = 1.0, size: CGFloat? = nil) -> Self {
        translatesAutoresizingMaskIntoConstraints = false

        addConstraint(NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: self, attribute: .width, multiplier: aspectRatio, constant: 0))
        if let size = size {
            let constraint = widthAnchor.constraint(equalToConstant: size)
            constraint.identifier = "\(ConstraintSide.width.rawValue)-\(ConstraintType.equal)"
            constraint.isActive = true
        }

        return self
    }

    /// Set minimum or maximum values for the height or width of a view
    @discardableResult
    func anchor(minHeight: CGFloat? = nil, maxHeight: CGFloat? = nil, minWidth: CGFloat? = nil, maxWidth: CGFloat? = nil) -> Self {
        translatesAutoresizingMaskIntoConstraints = false

        if let minHeight = minHeight {
            let constraint = heightAnchor.constraint(greaterThanOrEqualToConstant: minHeight)
            constraint.identifier = "\(ConstraintSide.height.rawValue)-\(ConstraintType.greaterThan)"
            constraint.isActive = true
        }
        if let maxHeight = maxHeight {
            let constraint = heightAnchor.constraint(lessThanOrEqualToConstant: maxHeight)
            constraint.identifier = "\(ConstraintSide.height.rawValue)-\(ConstraintType.lessThan)"
            constraint.isActive = true
        }
        if let minWidth = minWidth {
            let constraint = widthAnchor.constraint(greaterThanOrEqualToConstant: minWidth)
            constraint.identifier = "\(ConstraintSide.width.rawValue)-\(ConstraintType.greaterThan)"
            constraint.isActive = true
        }
        if let maxWidth = maxWidth {
            let constraint = widthAnchor.constraint(lessThanOrEqualToConstant: maxWidth)
            constraint.identifier = "\(ConstraintSide.width.rawValue)-\(ConstraintType.lessThan)"
            constraint.isActive = true
        }

        return self
    }

    /// Force the height of a view to be anchored to its intrinsic content size
    @discardableResult
    func anchorHeightToIntrinsicHeight(plus padding: CGFloat = 0) -> Self {
        if let existingConstraint = getConstraint(for: .height, withTag: "-intrinsic") {
            existingConstraint.constant = intrinsicContentSize.height + padding
            return self
        } else {
            return anchor(height: intrinsicContentSize.height + padding, heightTag: "-intrinsic")
        }
    }

    /// Force the width of a view to be anchored to its intrinsic content size
    @discardableResult
    func anchorWidthToIntrinsicWidth(plus padding: CGFloat = 0) -> Self {
        if let existingConstraint = getConstraint(for: .width, withTag: "-intrinsic") {
            existingConstraint.constant = intrinsicContentSize.width + padding
            return self
        } else {
            return anchor(width: intrinsicContentSize.width + padding, widthTag: "-intrinsic")
        }
    }
}
