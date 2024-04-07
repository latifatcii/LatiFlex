//
//  LatiFlexEventsItem.swift
//  LatiFlex
//
//  Created by Abdüllatif Atçı on 24.07.2022.
//  Copyright © 2022 Trendyol. All rights reserved.
//

import UIKit

private extension LatiFlexEventsItem {
    enum Constant {
        static let eventsImageName: String = "events"
    }
}

final class LatiFlexEventsItem: LatiFlexItemInterface {
    private let firstWindow = UIApplication.shared.windows.first

    var image: UIImage? {
        UIImage(named: Constant.eventsImageName)
    }
    
    func didSelectItem() {
        if var topController = firstWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            let eventNC = LatiFlexEventsRouter.createModule()
            if UIDevice.current.userInterfaceIdiom == .pad {
                eventNC.modalPresentationStyle = .overFullScreen
            }
            topController.present(eventNC, animated: true)
        }
    }
}
