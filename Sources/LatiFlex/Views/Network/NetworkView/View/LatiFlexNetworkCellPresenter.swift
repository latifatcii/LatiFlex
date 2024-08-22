//
//  LatiFlexNetworkCellPresenter.swift
//  LatiFlex
//
//  Created by Abdüllatif Atçı on 24.07.2022.
//  Copyright © 2022 Trendyol. All rights reserved.
//

import Foundation

protocol LatiFlexNetworkCellPresenterInterface {
    func load()
    func copyCurlButtonTapped()
}

struct LatiFlexNetworkCellPresenterArguments {
    let url: String?
    let statusCode: Int
    let method: String?
    let responseTime: String?
    let timeInterval: String?
    let curl: String?
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
            view?.setContainerStackViewColorToGreen()
            view?.setStatusImage(symbolName: "checkmark.circle")
        } else {
            view?.setContainerStackViewColorToRed()
            view?.setStatusImage(symbolName: "exclamationmark.octagon")
        }
    }
    
    func copyCurlButtonTapped() {
        view?.setTextToClipboard(argument.curl)
        view?.prepareCopyCurlButtonForCopiedState()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.view?.prepareCopyCurlButtonForDefaultState()
        }
    }
}
