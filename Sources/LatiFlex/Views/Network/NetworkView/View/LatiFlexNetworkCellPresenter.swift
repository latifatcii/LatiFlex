//
//  LatiFlexNetworkCellPresenter.swift
//  LatiFlex
//
//  Created by Abdüllatif Atçı on 24.07.2022.
//  Copyright © 2022 Trendyol. All rights reserved.
//

protocol LatiFlexNetworkCellPresenterInterface {
    func load()
}

struct LatiFlexNetworkCellPresenterArguments {
    let url: String?
    let statusCode: Int
    let method: String?
    let responseTime: String?
    let timeInterval: String?
}

final class LatiFlexNetworkCellPresenter {
    private weak var view: LatiFlexNetworkCellInterface?
    private let argument: LatiFlexNetworkCellPresenterArguments
    
    init(view: LatiFlexNetworkCellInterface?,
         argument: LatiFlexNetworkCellPresenterArguments) {
        self.view = view
        self.argument = argument
    }
}

extension LatiFlexNetworkCellPresenter: LatiFlexNetworkCellPresenterInterface {
    func load() {
        view?.prepareUI()
        view?.setTitleLabel(text: argument.url)
        view?.setHttpMethodLabel(text: argument.method)
        view?.setHttpStatusLabel(text: String(argument.statusCode))
        view?.setResponseTimeLabel(text: argument.responseTime)
        view?.setTimeIntervalLabel(text: argument.timeInterval)
        if (200...300).contains(argument.statusCode) {
            view?.setHttpContainerViewBackgrounColor(color: .orange)
        } else {
            view?.setHttpContainerViewBackgrounColor(color: .red)
        }
    }
}
