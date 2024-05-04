//
//  LatiFlexPresenter.swift
//
//
//  Created by Abdüllatif Atçı on 16.03.2024.
//

import Foundation

public struct LatiFlexEvents {
    let eventType: String
    let date: Date = Date()
    let name: String?
    let parameters: [String: String]
    
    init(
        eventType: String,
        name: String? = nil,
        parameters: [String : String]
    ) {
        self.eventType = eventType
        self.name = name
        self.parameters = parameters
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
