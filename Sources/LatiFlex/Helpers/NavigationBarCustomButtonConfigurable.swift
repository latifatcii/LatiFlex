//
//  NavigationBarCustomButtonConfigurable.swift
//
//
//  Created by Abdüllatif Atçı on 16.03.2024.
//

import UIKit

protocol NavigationBarCustomButtonConfigurable {
    var associatedNavigationItem: UINavigationItem { get }

    func removeCustomBarButton(on position: UINavigationItem.CustomBarButtonPosition)
    func setCustomBarButton(style: UINavigationItem.CustomBarButtonStyle, position: UINavigationItem.CustomBarButtonPosition, target: Any?, selector: Selector)
}

extension NavigationBarCustomButtonConfigurable {
    func setCustomBarButton(style: UINavigationItem.CustomBarButtonStyle, position: UINavigationItem.CustomBarButtonPosition, target: Any?, selector: Selector) {
        let barButtonItem: UIBarButtonItem

        switch style {
        case .textWithUIColor(let color, let font, let title):
            let button = UIButton(type: .custom)
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = font
            button.setTitleColor(color, for: .normal)
            button.addTarget(target, action: selector, for: .touchUpInside)
            barButtonItem = .init(customView: button)
            
        case .image(let image, let bundle):
            barButtonItem = .init(image: UIImage(named: image, in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysOriginal),
                                  style: .plain,
                                  target: target,
                                  action: selector)
            
        case .custom(let view):
            let button = UIButton()
            button.addTarget(target, action: selector, for: .touchUpInside)
            view.addSubview(button)
            button.embedEdgeToEdge(in: view)
            barButtonItem = UIBarButtonItem(customView: view)
        }

        associatedNavigationItem.setBarButtonOnPosition(barButton: barButtonItem, position: position)
    }
    
    func removeCustomBarButton(on position: UINavigationItem.CustomBarButtonPosition) {
        switch position {
        case .left:
            associatedNavigationItem.leftBarButtonItem = nil
            associatedNavigationItem.leftBarButtonItems = nil
        case .right:
            associatedNavigationItem.rightBarButtonItem = nil
            associatedNavigationItem.rightBarButtonItems = nil
        case .center:
            associatedNavigationItem.titleView = nil
        }
    }
}
