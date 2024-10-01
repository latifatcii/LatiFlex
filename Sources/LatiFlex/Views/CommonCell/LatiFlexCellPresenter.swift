//
//  LatiFlexCellPresenter.swift
//  LatiFlex
//
//  Created by Abdüllatif Atçı on 24.07.2022.
//  Copyright © 2022 Trendyol. All rights reserved.
//

protocol LatiFlexCellPresenterInterface {
    func load()
}

final class LatiFlexCellPresenter {
    private weak var view: LatiFlexCellInterface?
    private let title: String?
    private let detail: String?
    private let isSuccess: Bool

    init(view: LatiFlexCellInterface?,
         title: String?,
         detail: String?,
         isSuccess: Bool = false) {
        self.view = view
        self.title = title
        self.detail = detail
        self.isSuccess = isSuccess
    }
}

extension LatiFlexCellPresenter: LatiFlexCellPresenterInterface {
    func load() {
        view?.prepareUI()
        view?.setTitleLabel(text: title)
        view?.setDetailLabel(text: detail)
        view?.setDetailLabelTextColor(isSuccess ? .black : .red)
        view?.setDetailLabelVisibility(isHidden: detail?.isEmpty ?? true)
    }
}
