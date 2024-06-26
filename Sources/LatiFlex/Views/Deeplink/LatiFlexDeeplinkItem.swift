//
//  LatiFlexDeeplinkItem.swift
//  LatiFlex
//
//  Created by Abdüllatif Atçı on 24.07.2022.
//  Copyright © 2022 Trendyol. All rights reserved.
//

import UIKit

private extension LatiFlexDeeplinkItem {
    enum Constant {
        static let deeplinkImageName: String = "deeplinks"
    }
}

final class LatiFlexDeeplinkItem: LatiFlexItemInterface {
    private let firstWindow = UIApplication.shared.windows.first

    var image: UIImage? {
        UIImage(named: Constant.deeplinkImageName, in: .module, with: .none)
    }
    
    func didSelectItem(deeplinks: LatiFlexDeeplinksResponse) {
        if var topController = firstWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            let deeplinkNC = LatiFlexDeeplinkRouter.createModule(deeplinks: deeplinks)
            if UIDevice.current.userInterfaceIdiom == .pad {
                deeplinkNC.modalPresentationStyle = .overFullScreen
            }
            topController.present(deeplinkNC, animated: true)
        }
    }
}
