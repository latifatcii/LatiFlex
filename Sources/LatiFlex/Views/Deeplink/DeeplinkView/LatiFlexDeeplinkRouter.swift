//
//  LatiFlexDeeplinkRouter.swift
//  LatiFlex
//
//  Created by Abdüllatif Atçı on 24.07.2022.
//  Copyright © 2022 Trendyol. All rights reserved.
//

import UIKit

protocol LatiFlexDeeplinkRouterInterface: RouterInterface {
    func presentDeeplinkDetail(deeplinkList: [DeeplinkList]?)
}

final class LatiFlexDeeplinkRouter {
    weak var navigationController: UINavigationController?
    
    init(with navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    static func createModule(using navigationController: UINavigationController? = nil, deeplinks: LatiFlexDeeplinksResponse) -> UINavigationController {
        let deeplinkVC = LatiFlexDeeplinkViewController()
        let deeplinkNC = UINavigationController(rootViewController: deeplinkVC)
        let router = LatiFlexDeeplinkRouter(with: deeplinkNC)
        let deeplinkPresenter = LatiFlexDeeplinkPresenter(view: deeplinkVC, router: router, deeplinks: deeplinks)
        deeplinkVC.presenter = deeplinkPresenter
        deeplinkNC.modalPresentationStyle = .popover
        
        return deeplinkNC
    }
}

extension LatiFlexDeeplinkRouter: LatiFlexDeeplinkRouterInterface {
    func presentDeeplinkDetail(deeplinkList: [DeeplinkList]?) {
        let detailVC = LatiFlexDeeplinkDetailRouter.createModule(using: navigationController,
                                                                    deeplinkList: deeplinkList)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
