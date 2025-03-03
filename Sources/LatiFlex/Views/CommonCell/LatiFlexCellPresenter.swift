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

extension LatiFlexCellPresenter {
    struct Arguments {
        let title: String?
        let detail: String?
        let isSuccess: Bool

        init(title: String? = nil, detail: String? = nil, isSuccess: Bool = false) {
            self.title = title
            self.detail = detail
            self.isSuccess = isSuccess
        }
    }
}

final class LatiFlexCellPresenter {
    private weak var view: LatiFlexCellInterface?
    private let arguments: Arguments

    init(view: LatiFlexCellInterface?,
         arguments: Arguments) {
        self.view = view
        self.arguments = arguments
    }
}

extension LatiFlexCellPresenter: LatiFlexCellPresenterInterface {
    func load() {
        view?.prepareUI()
        view?.setTitleLabel(text: arguments.title)
        view?.setDetailLabel(text: arguments.detail)
        view?.setDetailLabelTextColor(arguments.isSuccess ? .black : .red)
        view?.setDetailLabelVisibility(isHidden: arguments.detail?.isEmpty ?? true)
    }
}
