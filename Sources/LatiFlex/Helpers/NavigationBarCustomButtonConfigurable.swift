//
//  NavigationBarCustomButtonConfigurable.swift
//
//
//  Created by Abdüllatif Atçı on 16.03.2024.
//

import UIKit

public protocol NavigationBarCustomButtonConfigurable {
    var associatedNavigationItem: UINavigationItem { get }

    func setHidesBackButton(isHidden: Bool, isAnimated: Bool)
    func removeCustomBarButton(on position: UINavigationItem.CustomBarButtonPosition)
    func setCustomBarButton(style: UINavigationItem.CustomBarButtonStyle, position: UINavigationItem.CustomBarButtonPosition, target: Any?, selector: Selector)
    func setCustomBarView(view: UIView, position: UINavigationItem.CustomBarButtonPosition)
    func setBarButtons(with arguments: [BarButtonArguments], position: UINavigationItem.CustomBarButtonPosition)
    func setBarButtonVisibility(position: UINavigationItem.CustomBarButtonPosition, isHidden: Bool)
}

public struct BarButtonArguments {
    public let style: UINavigationItem.CustomBarButtonStyle
    public let target: Any?
    public let selector: Selector

    public init(style: UINavigationItem.CustomBarButtonStyle, target: Any?, selector: Selector) {
        self.style = style
        self.target = target
        self.selector = selector
    }
}

public extension NavigationBarCustomButtonConfigurable {
    func setBarButtonVisibility(position: UINavigationItem.CustomBarButtonPosition, isHidden: Bool) {
        switch position {
        case .left:
            associatedNavigationItem.leftBarButtonItem?.customView?.isHidden = isHidden
        case .right:
            associatedNavigationItem.rightBarButtonItem?.customView?.isHidden = isHidden
        case .center:
            associatedNavigationItem.titleView?.isHidden = isHidden
        }
    }

    func setHidesBackButton(isHidden: Bool, isAnimated: Bool) {
        associatedNavigationItem.setHidesBackButton(isHidden, animated: isAnimated)
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
    
    func setCustomBarView(view: UIView, position: UINavigationItem.CustomBarButtonPosition) {
        let barButtonItem = UIBarButtonItem(customView: view)
        associatedNavigationItem.setBarButtonOnPosition(barButton: barButtonItem, position: position)
    }

    func setBarButtons(with arguments: [BarButtonArguments], position: UINavigationItem.CustomBarButtonPosition) {
        let barbuttons: [UIBarButtonItem] = arguments.compactMap { argument in
            switch argument.style {
            case .custom(let view):
                let barButtonItem: UIBarButtonItem
                let button = UIButton()
                button.addTarget(argument.target, action: argument.selector, for: .touchUpInside)
                view.addSubview(button)
                button.embedEdgeToEdge(in: view)
                barButtonItem = UIBarButtonItem(customView: view)
                return barButtonItem
            case .image(let imageName, let bundle):
                guard let image = UIImage(named: imageName, in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysOriginal) else { return nil }
                return UIBarButtonItem(image: image, style: .plain, target: argument.target, action: argument.selector)
            default:
                return nil
            }
        }
        associatedNavigationItem.setBarButtons(barButtons: barbuttons, position: position)
    }
}
