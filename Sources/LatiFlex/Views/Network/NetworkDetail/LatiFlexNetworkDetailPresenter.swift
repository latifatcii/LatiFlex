//
//  LatiFlexNetworkDetailPresenter.swift
//  LatiFlex
//
//  Created by Abdüllatif Atçı on 24.07.2022.
//  Copyright © 2022 Trendyol. All rights reserved.
//

import Foundation

protocol LatiFlexNetworkDetailPresenterInterface {
    var numberOfItems: Int { get }
    
    func viewDidLoad()
    func keyAt(index: Int) -> String?
    func valueAt(index: Int) -> String?
}

private extension LatiFlexNetworkDetailPresenter {
    enum Constant {
        static let copyCurlString: String = "Copy Curl"
        static let copiedCurlString: String = "Copied The Curl"
        static let responseString: String = "Response"
        static let fontSize: Double = 17
    }
}

final class LatiFlexNetworkDetailPresenter {
    private weak var view: LatiFlexNetworkDetailViewInterface?
    private let router: LatiFlexNetworkDetailRouterInterface
    private let networkModel: LatiFlexNetworkingModel?
    private var items: [String: Any]? {
        var httpHeaders = networkModel?.request?.allHTTPHeaderFields
        httpHeaders?["Url"] = networkModel?.request?.url?.absoluteString
        httpHeaders?["HTTP Body"] = try? networkModel?.request?.httpBodyStream?.readData().prettyPrintedString
        return httpHeaders
    }
    private var keys: [String]?
    private var values: [String]?
    
    init(view: LatiFlexNetworkDetailViewInterface?,
         router: LatiFlexNetworkDetailRouterInterface,
         networkModel: LatiFlexNetworkingModel?) {
        self.view = view
        self.router = router
        self.networkModel = networkModel
    }
    
    @objc private func responseButtonTapped() {
        guard let response = networkModel?.data.prettyPrintedString else { return }
        router.presentNetworkResponse(response: response)
    }
    
    @objc private func copyCurlButtonTapped() {
        guard let curl = networkModel?.request?.curlString else { return }
        view?.removeCustomBarButton(on: .center)
        view?.setCustomBarButton(style: .textWithUIColor(color: .systemGreen,
                                                         font: .systemFont(ofSize: Constant.fontSize, weight: .semibold),
                                                         title: Constant.copiedCurlString),
                                 position: .center,
                                 target: self,
                                 selector: #selector(copyCurlButtonTapped))
        view?.setToPasteboard(curl)
    }
}

extension LatiFlexNetworkDetailPresenter: LatiFlexNetworkDetailPresenterInterface {
    var numberOfItems: Int {
        items?.count ?? .zero
    }
    
    func viewDidLoad() {
        view?.prepareUI()
        view?.setCustomBarButton(style: .textWithUIColor(color: .black,
                                                         font: .systemFont(ofSize: Constant.fontSize, weight: .semibold),
                                                         title: Constant.responseString),
                                 position: .right,
                                 target: self,
                                 selector: #selector(responseButtonTapped))
        view?.setCustomBarButton(style: .textWithUIColor(color: .red,
                                                         font: .systemFont(ofSize: Constant.fontSize, weight: .semibold),
                                                         title: Constant.copyCurlString),
                                 position: .center,
                                 target: self,
                                 selector: #selector(copyCurlButtonTapped))
        keys = items?.map { $0.key }
        values = items?.compactMap { $0.value as? String }

    }
    
    func keyAt(index: Int) -> String? {
        keys?[index]
    }
    
    func valueAt(index: Int) -> String? {
        values?[index]
    }
}

extension Data {
    var prettyPrintedString: String? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: [.mutableLeaves]),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
        return prettyPrintedString as String
    }
}
