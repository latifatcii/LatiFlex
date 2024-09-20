//
//  LatiFlexNetworkDetailCellPresenter.swift
//  LatiFlex
//
//  Created by Latif Atci on 20.09.2024.
//

protocol LatiFlexNetworkDetailCellPresenterInterface {
    func load()
}

final class LatiFlexNetworkDetailCellPresenter {
    private weak var view: LatiFlexNetworkDetailCellInterface?
    private let title: String?
    private let detail: String?
    
    init(view: LatiFlexNetworkDetailCellInterface?,
         title: String?,
         detail: String?) {
        self.view = view
        self.title = title
        self.detail = detail
    }
}

extension LatiFlexNetworkDetailCellPresenter: LatiFlexNetworkDetailCellPresenterInterface {
    func load() {
        view?.prepareUI()
        view?.setTitleLabel(text: title)
        view?.setDetailLabel(text: detail)
        view?.setDetailLabelVisibility(isHidden: detail?.isEmpty ?? true)
    }
}
