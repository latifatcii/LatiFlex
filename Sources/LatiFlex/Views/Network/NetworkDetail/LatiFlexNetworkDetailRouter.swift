//
//  LatiFlexNetworkDetailRouter.swift
//  LatiFlex
//
//  Created by Abdüllatif Atçı on 24.07.2022.
//  Copyright © 2022 Trendyol. All rights reserved.
//

import UIKit

protocol LatiFlexNetworkDetailRouterInterface: RouterInterface {
    func presentNetworkResponse(response: String)
}

final class LatiFlexNetworkDetailRouter {
    weak var navigationController: UINavigationController?
    
    init(with navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    static func createModule(using navigationController: UINavigationController? = nil, networkModel: LatiFlexNetworkingModel?) -> UIViewController {
        let networkVC = LatiFlexNetworkDetailViewController()
        let router = LatiFlexNetworkDetailRouter(with: navigationController)
        let eventPresenter = LatiFlexNetworkDetailPresenter(view: networkVC,
                                                               router: router,
        networkModel: networkModel)
        networkVC.presenter = eventPresenter
        
        return networkVC
    }
}

extension LatiFlexNetworkDetailRouter: LatiFlexNetworkDetailRouterInterface {
    func presentNetworkResponse(response: String) {
        let detailVC = LatiFlexNetworkDetailResponseViewController()
        let detailPresenter = LatiFlexNetworkDetailResponsePresenter(view: detailVC,
                                                                response: response)
        detailVC.presenter = detailPresenter
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
