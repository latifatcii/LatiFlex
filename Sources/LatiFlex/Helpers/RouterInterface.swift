//
//  RouterInterface.swift
//
//
//  Created by Abdüllatif Atçı on 16.03.2024.
//

import UIKit

protocol RouterInterface: AnyObject {
    var navigationController: UINavigationController? { get set }

    func dismissModule(animated: Bool)
    func dismissModule(animated: Bool, completion: (() -> Void)?)
}

extension RouterInterface {
    func dismissModule(animated: Bool) {
        navigationController?.dismiss(animated: animated, completion: nil)
    }
    
    func dismissModule(animated: Bool, completion: (() -> Void)?) {
        navigationController?.dismiss(animated: animated, completion: completion)
    }
}
