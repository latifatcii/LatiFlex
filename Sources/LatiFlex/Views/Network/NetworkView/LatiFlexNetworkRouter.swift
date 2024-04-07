//
//  LatiFlexNetworkRouter.swift
//  LatiFlex
//
//  Created by Abdüllatif Atçı on 24.07.2022.
//  Copyright © 2022 Trendyol. All rights reserved.
//

import UIKit

protocol LatiFlexNetworkRouterInterface: RouterInterface {
    func presentNetworkDetail(networkModel: LatiFlexNetworkingModel?)
}

final class LatiFlexNetworkRouter {
    weak var navigationController: UINavigationController?
    
    init(with navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    static func createModule(using navigationController: UINavigationController? = nil) -> UINavigationController {
        let networkVC = LatiFlexNetworkViewController()
        let networkNC = UINavigationController(rootViewController: networkVC)
        let router = LatiFlexNetworkRouter(with: networkNC)
        let eventPresenter = LatiFlexNetworkPresenter(view: networkVC, router: router)
        networkVC.presenter = eventPresenter
        networkNC.modalPresentationStyle = .popover
        
        return networkNC
    }
}

extension LatiFlexNetworkRouter: LatiFlexNetworkRouterInterface {
    func presentNetworkDetail(networkModel: LatiFlexNetworkingModel?) {
        let detailVC = LatiFlexNetworkDetailRouter.createModule(using: navigationController,
                                                                networkModel: networkModel)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
