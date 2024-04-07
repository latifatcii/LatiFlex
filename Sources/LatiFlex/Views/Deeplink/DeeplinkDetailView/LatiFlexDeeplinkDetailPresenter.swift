//
//  LatiFlexDeeplinkDetailPresenter.swift
//  LatiFlex
//
//  Created by Abdüllatif Atçı on 24.07.2022.
//  Copyright © 2022 Trendyol. All rights reserved.
//

import Foundation

protocol LatiFlexDeeplinkDetailPresenterInterface {
    var numberOfItems: Int { get }
    
    func viewDidLoad()
    func itemAt(index: Int) -> DeeplinkList?
    func didSelectItemAt(index: Int)
    func routeButtonTapped()
    func scrollViewDidScroll()
}

private extension LatiFlexDeeplinkDetailPresenter {
    enum Constant {
        static let recentDeeplinksTitle: String = "Recent"
    }
}

final class LatiFlexDeeplinkDetailPresenter {
    private weak var view: LatiFlexDeeplinkDetailViewInterface?
    private let router: LatiFlexDeeplinkDetailRouterInterface
    private let deeplinkList: [DeeplinkList]?
    private var recentDeeplinkList: () -> [DeeplinkList]
    private var appendRecentSearchedDeeplinks: ([DeeplinkList]) -> ()
    private var appendableDeeplinkList: [DeeplinkList] = []
    
    init(view: LatiFlexDeeplinkDetailViewInterface?,
         router: LatiFlexDeeplinkDetailRouterInterface,
         deeplinkList: [DeeplinkList]?,
         recentDeeplinkList: @escaping () -> [DeeplinkList] = { LatiFlex.shared.deeplinkList },
         appendRecentSearchedDeeplinks: @escaping ([DeeplinkList]) -> () = { LatiFlex.shared.deeplinkList = $0}) {
        self.view = view
        self.router = router
        self.deeplinkList = deeplinkList
        self.recentDeeplinkList = recentDeeplinkList
        self.appendRecentSearchedDeeplinks = appendRecentSearchedDeeplinks
    }
}

extension LatiFlexDeeplinkDetailPresenter: LatiFlexDeeplinkDetailPresenterInterface {
    var numberOfItems: Int {
        deeplinkList?.count ?? .zero
    }
    
    func viewDidLoad() {
        view?.prepareUI()
        appendableDeeplinkList = recentDeeplinkList()
    }
    
    func itemAt(index: Int) -> DeeplinkList? {
        deeplinkList?[index]
    }
    
    func didSelectItemAt(index: Int) {
        view?.setTextField(text: deeplinkList?[index].deeplink)
        view?.endEditing()
    }
    
    func routeButtonTapped() {
        guard let text = view?.deeplinkText, let url = URL(string: text) else { return }
        router.dismissModule(animated: true) { [weak self] in
            self?.router.openUrl(url)
        }
        appendableDeeplinkList.append(.init(name: Constant.recentDeeplinksTitle, deeplink: text))
        appendRecentSearchedDeeplinks(appendableDeeplinkList)
    }
    
    func scrollViewDidScroll() {
        view?.endEditing()
    }
}
