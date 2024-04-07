//
//  LatiFlexNetworkPresenter.swift
//  LatiFlex
//
//  Created by Abdüllatif Atçı on 24.07.2022.
//  Copyright © 2022 Trendyol. All rights reserved.
//

import Foundation

protocol LatiFlexNetworkPresenterInterface {
    var numberOfItems: Int { get }
    
    func viewDidLoad()
    func argumentAt(index: Int) -> LatiFlexNetworkCellPresenterArguments
    func textDidChange(searchtext: String)
    func didSelectItem(at index: Int)
}

private extension LatiFlexNetworkPresenter {
    enum Constant {
        static let closeButtonImage: String = "LatiFlexCloseButtonIcon"
        static let deleteIconImage: String = "LatiFlexDeleteButtonIcon"
    }
}

final class LatiFlexNetworkPresenter {
    private weak var view: LatiFlexNetworkViewInterface?
    private let router: LatiFlexNetworkRouterInterface
    private var latiFlexNetworkModels: () -> [LatiFlexNetworkingModel]
    private var filteredNetworkModels: [LatiFlexNetworkingModel] = []
    private var removeLatiFlexNetworkModels: ([LatiFlexNetworkingModel]) -> ()
    private let dateFormatter: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss.SSS"
        return dateFormatter
    }()
    
    init(view: LatiFlexNetworkViewInterface?,
         router: LatiFlexNetworkRouterInterface,
         latiFlexNetworkModels: @escaping () -> [LatiFlexNetworkingModel] = { LatiFlex.shared.networkingModel.reversed() },
         removeLatiFlexNetworkModels: @escaping ([LatiFlexNetworkingModel]) -> () = { LatiFlex.shared.networkingModel = $0 }) {
        self.view = view
        self.router = router
        self.latiFlexNetworkModels = latiFlexNetworkModels
        self.removeLatiFlexNetworkModels = removeLatiFlexNetworkModels
    }
    
    @objc private func closeButtonTapped() {
        router.dismissModule(animated: true)
    }
    
    @objc private func deleteButtonTapped() {
        removeLatiFlexNetworkModels([])
        filteredNetworkModels = latiFlexNetworkModels()
        view?.reloadData()
    }
    
    private func urlAt(index: Int) -> String? {
        guard let url = filteredNetworkModels[index].request?.url else { return nil }
        return url.absoluteString
    }
    
    private func statusCodeAt(index: Int) -> Int {
        guard let response = filteredNetworkModels[index].response as? HTTPURLResponse else { return -1 }
        return response.statusCode
    }
    
    private func httpMethodAt(index: Int) -> String? {
        filteredNetworkModels[index].request?.httpMethod
    }
    
    private func responseTimeAt(index: Int) -> String? {
        guard let responseTime = filteredNetworkModels[index].endTime else { return nil }
        return dateFormatter.string(from: responseTime)
    }
    
    private func timeIntervalAt(index: Int) -> String? {
        guard let timeInterval = filteredNetworkModels[index].timeInterval else { return nil }
        return String(format: "%.3f sn", timeInterval)
    }
}

extension LatiFlexNetworkPresenter: LatiFlexNetworkPresenterInterface {
    var numberOfItems: Int { filteredNetworkModels.count }
    
    func viewDidLoad() {
        view?.prepareUI()
        filteredNetworkModels = latiFlexNetworkModels()
        view?.setCustomBarButton(style: .image(image: Constant.closeButtonImage,
                                               bundle: .module),
                                 position: .left,
                                 target: self,
                                 selector: #selector(closeButtonTapped))
        view?.setCustomBarButton(style: .image(image: Constant.deleteIconImage,
                                               bundle: .module),
                                 position: .right,
                                 target: self,
                                 selector: #selector(deleteButtonTapped))
    }
    
    func argumentAt(index: Int) -> LatiFlexNetworkCellPresenterArguments {
        LatiFlexNetworkCellPresenterArguments(url: urlAt(index: index),
                                              statusCode: statusCodeAt(index: index),
                                              method: httpMethodAt(index: index),
                                              responseTime: responseTimeAt(index: index),
                                              timeInterval: timeIntervalAt(index: index))
    }
    
    func textDidChange(searchtext: String) {
        guard !searchtext.isEmpty else {
            filteredNetworkModels = latiFlexNetworkModels()
            view?.reloadData()
            return
        }
        filteredNetworkModels = latiFlexNetworkModels().filter {
            if let _: Range = $0.data.prettyPrintedString?.lowercased(with: Locale.current).range(of: searchtext.lowercased(with: Locale.current)) {
                return true
            }
            return false
        }
        view?.reloadData()
    }
    
    func didSelectItem(at index: Int) {
        let networkModel = filteredNetworkModels[index]
        router.presentNetworkDetail(networkModel: networkModel)
    }
}
