//
//  UINavigationItem+Extension.swift
//
//
//  Created by Abdüllatif Atçı on 16.03.2024.
//

import UIKit

public extension UINavigationItem {
    enum CustomBarButtonPosition {
        case left
        case right
        case center
    }
    
    enum CustomBarButtonStyle {
        case textWithUIColor(color: UIColor, font: UIFont, title: String)
        case image(image: String, bundle: Bundle?)
        case custom(view: UIView)
    }
    
    func setBarButtonOnPosition(barButton: UIBarButtonItem, position: CustomBarButtonPosition) {
        switch position {
        case .left:
            leftBarButtonItem = barButton
        case .right:
            rightBarButtonItem = barButton
        case .center:
            titleView = barButton.view
        }
    }

    func setBarButtons(barButtons: [UIBarButtonItem], position: CustomBarButtonPosition) {
        switch position {
        case .right:
            rightBarButtonItems = barButtons
        case .left:
            leftBarButtonItems = barButtons
        default:
            break
        }
    }
}

extension UINavigationItem.CustomBarButtonStyle: Equatable {
    static public func ==(lhs: UINavigationItem.CustomBarButtonStyle, rhs: UINavigationItem.CustomBarButtonStyle) -> Bool {
        switch (lhs, rhs) {
        case (.textWithUIColor(let colorFirst, let fontFirst, let titleFirst), .textWithUIColor(let colorSecond, let fontSecond, let titleSecond)):
            return colorFirst == colorSecond && fontFirst.fontName == fontSecond.fontName && titleFirst == titleSecond
        case (.image(let imageFirst, let bundleFirst), .image(let imageSecond, let bundleSecond)):
            return imageFirst == imageSecond && bundleFirst == bundleSecond
        case (.custom(let viewFirst), .custom(let viewSecond)):
            return viewFirst == viewSecond
        default: return false
        }
    }
}

extension UIBarButtonItem {
    public convenience init(image: UIImage?, style: UIBarButtonItem.Style, target: Any?, action: Selector?, accessibilityIdentifier: String?) {
        self.init(image: image, style: style, target: target, action: action)
        self.accessibilityIdentifier = accessibilityIdentifier
    }
}

public extension UIBarItem {
    var view: UIView? {
        if let item = self as? UIBarButtonItem, let customView = item.customView {
            return customView
        }
        return value(forKey: "view") as? UIView
    }
}
