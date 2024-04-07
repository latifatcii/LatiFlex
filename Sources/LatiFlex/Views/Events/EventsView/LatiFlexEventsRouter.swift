//
//  LatiFlexEventsRouter.swift
//  LatiFlex
//
//  Created by Abdüllatif Atçı on 24.07.2022.
//  Copyright © 2022 Trendyol. All rights reserved.
//

import UIKit

protocol LatiFlexEventsRouterInterface: RouterInterface {
    func presentEventDetail(eventParameters: [String: String]?)
}

final class LatiFlexEventsRouter {
    weak var navigationController: UINavigationController?
    
    init(with navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    static func createModule(using navigationController: UINavigationController? = nil) -> UINavigationController {
        let eventVC = LatiFlexEventsViewController()
        let eventNC = UINavigationController(rootViewController: eventVC)
        let router = LatiFlexEventsRouter(with: eventNC)
        let eventPresenter = LatiFlexEventPresenter(view: eventVC, router: router)
        eventVC.presenter = eventPresenter
        eventNC.modalPresentationStyle = .popover
        
        return eventNC
    }
}

extension LatiFlexEventsRouter: LatiFlexEventsRouterInterface {
    func presentEventDetail(eventParameters: [String: String]?) {
        let detailVC = LatiFlexEventsDetailRouter.createModule(using: navigationController, eventParameters: eventParameters)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
