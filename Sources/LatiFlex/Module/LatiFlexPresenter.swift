//
//  LatiFlexPresenter.swift
//
//
//  Created by Abdüllatif Atçı on 16.03.2024.
//

import Foundation

public enum LatiFlexEventResult {
    case success(name: String, parameters: [String: Any])
    case failure(Error)
}

public struct LatiFlexEvents {
    let date: Date = Date()

    let eventType: String
    let eventResult: LatiFlexEventResult

    init(
        eventType: String,
        eventResult: LatiFlexEventResult
    ) {
        self.eventType = eventType
        self.eventResult = eventResult
    }
}

public struct LatiFlexNetworkingModel {
    var request: URLRequest?
    var data: Data = Data()
    var response: URLResponse?
    // The date when the request started
    var startTime: Date?
    // The date when the request ended
    var endTime: Date?
    // Time passes between start and end
    var timeInterval: Float?
    
    mutating func update(with response: URLResponse, finishedDate: Date = Date()) {
        self.response = response
        endTime = finishedDate
        if let startTime = startTime {
            timeInterval = Float(finishedDate.timeIntervalSince(startTime))
        }
    }
}

protocol LatiFlexPresenterInterface {
    var itemCount: Int { get }
    var items: [LatiFlexItemInterface] { get set }
    
    func itemAt(index: Int) -> LatiFlexItemInterface?
    func didSelectItemAt(index: Int, deeplinks: LatiFlexDeeplinksResponse?)
}

final class LatiFlexPresenter {
    var items: [LatiFlexItemInterface] = []
}

extension LatiFlexPresenter: LatiFlexPresenterInterface {
    var itemCount: Int {
        items.count - 1
    }
    
    func itemAt(index: Int) -> LatiFlexItemInterface? {
        items[index]
    }
    
    func didSelectItemAt(index: Int, deeplinks: LatiFlexDeeplinksResponse?) {
        if items[index] is LatiFlexDeeplinkItem, let deeplinks = deeplinks {
            items[index].didSelectItem(deeplinks: deeplinks)
            return
        }
        items[index].didSelectItem()
    }
}
