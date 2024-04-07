//
//  UINavigationItem+Extension.swift
//
//
//  Created by Abdüllatif Atçı on 16.03.2024.
//

import UIKit

extension UINavigationItem {
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
}

extension UIBarItem {
    var view: UIView? {
        if let item = self as? UIBarButtonItem, let customView = item.customView {
            return customView
        }
        return value(forKey: "view") as? UIView
    }
}
