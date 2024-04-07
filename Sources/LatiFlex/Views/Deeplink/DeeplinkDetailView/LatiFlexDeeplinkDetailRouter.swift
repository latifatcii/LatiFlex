//
//  LatiFlexDeeplinkDetailRouter.swift
//  LatiFlex
//
//  Created by Abdüllatif Atçı on 24.07.2022.
//  Copyright © 2022 Trendyol. All rights reserved.
//

import UIKit

protocol LatiFlexDeeplinkDetailRouterInterface: RouterInterface, UrlOpenable { }

final class LatiFlexDeeplinkDetailRouter {
    weak var navigationController: UINavigationController?
    
    init(with navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    static func createModule(using navigationController: UINavigationController? = nil, deeplinkList: [DeeplinkList]?) -> UIViewController {
        let detailVC = LatiFlexDeeplinkDetailViewController()
        let router = LatiFlexDeeplinkDetailRouter(with: navigationController)
        let detailPresenter = LatiFlexDeeplinkDetailPresenter(view: detailVC, router: router, deeplinkList: deeplinkList)
        detailVC.presenter = detailPresenter
        
        return detailVC
    }
}

extension LatiFlexDeeplinkDetailRouter: LatiFlexDeeplinkDetailRouterInterface { }
