//
//  LatiFlexEventsDetailRouter.swift
//  LatiFlex
//
//  Created by Abdüllatif Atçı on 24.07.2022.
//  Copyright © 2022 Trendyol. All rights reserved.
//

import UIKit

protocol LatiFlexEventsDetailRouterInterface: RouterInterface {
    func presentEventDetail(deeplinkList: [DeeplinkList]?)
}

final class LatiFlexEventsDetailRouter {
    weak var navigationController: UINavigationController?
    
    init(with navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    static func createModule(using navigationController: UINavigationController? = nil, eventParameters: [String: Any]?) -> UIViewController {
        let detailVC = LatiFlexEventsDetailViewController()
        let router = LatiFlexEventsDetailRouter(with: navigationController)
        let detailPresenter = LatiFlexEventsDetailPresenter(view: detailVC,
                                                            router: router,
                                                            eventParameters: eventParameters)
        detailVC.presenter = detailPresenter
        
        return detailVC
    }
}

extension LatiFlexEventsDetailRouter: LatiFlexEventsDetailRouterInterface {
    func presentEventDetail(deeplinkList: [DeeplinkList]?) {
        let detailVC = LatiFlexDeeplinkDetailRouter.createModule(using: navigationController,
                                                                 deeplinkList: deeplinkList)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
