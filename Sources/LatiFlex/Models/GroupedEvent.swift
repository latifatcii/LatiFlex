//
//  GroupedEvent.swift
//  LatiFlex
//
//  Created by Claude on 2025-09-06.
//  Copyright © 2025 Trendyol. All rights reserved.
//

import Foundation

struct GroupedEvent {
    let title: String
    let subtitle: String?
    let events: [LatiFlexEvents]
    let isExpanded: Bool
    
    var count: Int {
        events.count
    }
    
    var firstEventDate: Date? {
        events.first?.date
    }
    
    var lastEventDate: Date? {
        events.last?.date
    }
    
    var dateRangeText: String? {
        guard let first = firstEventDate,
              let last = lastEventDate,
              first != last else { return nil }
        
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        
        return "\(formatter.string(from: first)) - \(formatter.string(from: last))"
    }
    
    var isSuccess: Bool {
        events.first?.eventResult.isSuccess ?? false
    }
    
    func toggleExpanded() -> GroupedEvent {
        GroupedEvent(title: title, subtitle: subtitle, events: events, isExpanded: !isExpanded)
    }
}