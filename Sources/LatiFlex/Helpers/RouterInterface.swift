//
//  RouterInterface.swift
//
//
//  Created by Abdüllatif Atçı on 16.03.2024.
//

import UIKit

public protocol RouterInterface: AnyObject {
    var navigationController: UINavigationController? { get set }

    func popModule(animated: Bool)
    func popToRoot(animated: Bool)
    func dismissModule(animated: Bool)
    func dismissModule(animated: Bool, completion: (() -> Void)?)
    func dismissPresentedModule(animated: Bool, completion: (() -> Void)?)
}

public extension RouterInterface {
    func popModule(animated: Bool) {
        navigationController?.popViewController(animated: animated)
    }
    
    func popToRoot(animated: Bool) {
        navigationController?.popToRootViewController(animated: true)
    }

    func dismissModule(animated: Bool) {
        navigationController?.dismiss(animated: animated, completion: nil)
    }
    
    func dismissModule(animated: Bool, completion: (() -> Void)?) {
        navigationController?.dismiss(animated: animated, completion: completion)
    }

    func dismissPresentedModule(animated: Bool, completion: (() -> Void)?) {
        navigationController?.presentedViewController?.dismiss(animated: animated, completion: completion)
    }
}
