//
//  LatiFlexNetworkItem.swift
//  LatiFlex
//
//  Created by Abdüllatif Atçı on 24.07.2022.
//  Copyright © 2022 Trendyol. All rights reserved.
//

import UIKit

private extension LatiFlexNetworkItem {
    enum Constant {
        static let networkImageView: String = "network"
    }
}

final class LatiFlexNetworkItem: LatiFlexItemInterface {
    private let firstWindow = UIApplication.shared.windows.first

    var image: UIImage? {
        UIImage(named: Constant.networkImageView, in: .module, with: .none)
    }
    
    func didSelectItem() {
        if var topController = firstWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            let networkNC = LatiFlexNetworkRouter.createModule()
            if UIDevice.current.userInterfaceIdiom == .pad {
                networkNC.modalPresentationStyle = .overFullScreen
            }
            topController.present(networkNC, animated: true)
        }
    }
}
