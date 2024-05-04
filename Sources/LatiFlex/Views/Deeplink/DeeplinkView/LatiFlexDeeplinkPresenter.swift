//
//  LatiFlexDeeplinkPresenter.swift
//  LatiFlex
//
//  Created by Abdüllatif Atçı on 24.07.2022.
//  Copyright © 2022 Trendyol. All rights reserved.
//

import Foundation

protocol LatiFlexDeeplinkPresenterInterface {
    var numberOfItems: Int { get }
    
    func viewDidLoad()
    func didSelectItemAt(index: Int)
    func titleAt(index: Int) -> String
}

extension LatiFlexDeeplinkPresenter {
    enum Constant {
        static let closeButtonImage: String = "DebuggerKitCloseButtonIcon"
    }
}

final class LatiFlexDeeplinkPresenter {
    private weak var view: LatiFlexDeeplinkViewInterface?
    private var router: LatiFlexDeeplinkRouterInterface
    
    private var deeplinks: LatiFlexDeeplinksResponse
        
    private var deeplinkList: () -> [DeeplinkList]
    
    init(view: LatiFlexDeeplinkViewInterface?,
         router: LatiFlexDeeplinkRouterInterface,
         deeplinks: LatiFlexDeeplinksResponse,
         deeplinkList: @escaping () -> [DeeplinkList] = { LatiFlex.shared.deeplinkList }) {
        self.view = view
        self.router = router
        self.deeplinks = deeplinks
        self.deeplinkList = deeplinkList
    }
    
    @objc private func closeButtonTapped() {
        router.dismissModule(animated: true)
    }
}

extension LatiFlexDeeplinkPresenter: LatiFlexDeeplinkPresenterInterface {
    var numberOfItems: Int {
        deeplinks.deeplinkList.count
    }
    
    func titleAt(index: Int) -> String {
        deeplinks.deeplinkList[index].domainName
    }
    
    func didSelectItemAt(index: Int) {
        let deeplinkList = (index == (deeplinks.deeplinkList.count - 1) ? deeplinkList() : deeplinks.deeplinkList[index].deeplinks)
        router.presentDeeplinkDetail(deeplinkList: deeplinkList)
    }
    
    func viewDidLoad() {
        view?.prepareUI()
        view?.setCustomBarButton(style: .image(image: Constant.closeButtonImage,
                                               bundle: .module),
                                 position: .left,
                                 target: self,
                                 selector: #selector(closeButtonTapped))

    }
}
