//
//  LatiFlexEventsPresenter.swift
//  LatiFlex
//
//  Created by Abdüllatif Atçı on 24.07.2022.
//  Copyright © 2022 Trendyol. All rights reserved.
//

import Foundation

protocol LatiFlexEventsPresenterInterface {
    var numberOfItems: Int { get }
    var isSummarizeSwitchEnabled: Bool { get }

    func viewDidLoad()
    func didSelectItem(at index: Int)
    func selectedSegmentChanged(index: Int)
    func arguments(at index: Int) -> LatiFlexCellPresenter.Arguments
    func textDidChange(searchtext: String)
    func summarizeSwitchChanged(isOn: Bool)
    func shouldShowGrouped() -> Bool
    func isGroupHeader(at index: Int) -> Bool
    func groupedEventForIndex(_ index: Int) -> GroupedEvent?
    func expandAll()
    func collapseAll()
}

private extension LatiFlexEventPresenter {
    enum Constant {
        static let closeButtonImage: String = "DebuggerKitCloseButtonIcon"
        static let deleteIconImage: String = "DebuggerKitDeleteButtonIcon"
        static let failedEventText = "Failed Event"
        static let summarizeSwitchUserDefaultKey = "summarizeSwitchIsOn"
    }

    enum Events: String, CaseIterable {
        case Adjust
        case Delphoi
        case Demeter
        case Firebase
        case Facebook
        case NewRelic
        case CleverTap

        var shouldUseNameAsTitle: Bool { self == .Demeter }
        var eventKey: String {
            switch self {
            case .Firebase:
                return "eventCategory"
            default:
                return "event"
            }
        }

        var groupKey: String? {
            switch self {
            case .Delphoi:
                return "tv003"
            case .Demeter:
                return "event_group"
            default:
                return nil
            }
        }
    }
}

final class LatiFlexEventPresenter {
    private weak var view: LatiFlexEventsViewInterface?
    private let router: LatiFlexEventsRouterInterface
    private var latiFlexEvents: () -> [LatiFlexEvents]
    private var filteredLatiFlexEvents: [LatiFlexEvents] = []
    private var searchedLatiFlexEvents: [LatiFlexEvents]?
    private var currentEventList: [LatiFlexEvents] { searchedLatiFlexEvents ?? filteredLatiFlexEvents }
    private var removeLatiFlexEvents: ([LatiFlexEvents]) -> ()
    private var selectedIndex: Int = .zero
    private var isSummarizeEnabled: Bool = false
    private var groupedEvents: [GroupedEvent] = []
    private var expandedGroups: Set<String> = []

    init(view: LatiFlexEventsViewInterface?,
         router: LatiFlexEventsRouterInterface,
         latiFlexEvents: @escaping () -> [LatiFlexEvents] = { LatiFlex.shared.events.reversed() },
         removeLatiFlexEvents: @escaping ([LatiFlexEvents]) -> () = { LatiFlex.shared.events = $0 }) {
        self.view = view
        self.router = router
        self.latiFlexEvents = latiFlexEvents
        self.removeLatiFlexEvents = removeLatiFlexEvents
        self.isSummarizeEnabled = UserDefaults.standard.bool(forKey: Constant.summarizeSwitchUserDefaultKey)
    }

    @objc private func closeButtonTapped() {
        router.dismissModule(animated: true)
    }

    @objc private func deleteButtonTapped() {
        removeLatiFlexEvents([])
        filteredLatiFlexEvents = latiFlexEvents().filter { $0.eventType == LatiFlex.shared.eventTypes[selectedIndex] }
        updateGroupedEvents()
        view?.reloadData()
    }

    private func checkEventContains(event: LatiFlexEventResult, keyword: String) -> Bool {
        let lowercasedKeyword = keyword.lowercased()
        switch event {
        case .success(let name, let parameters):
            let isNameContainsKeyword = compare(string: name)
            let isParametersContainsKeyword = parameters.contains(where: { compare(string: "\($0.key)\($0.value)") })
            return isNameContainsKeyword || isParametersContainsKeyword
        case .failure(let error):
            return compare(string: error.localizedDescription)
        }
        func compare(string: String?) -> Bool { string?.lowercased().contains(lowercasedKeyword) ?? false }
    }

    private func title(event : LatiFlexEvents) -> String? {
        guard let eventType = Events(rawValue: event.eventType) else { return nil }
        let eventTypeValue = eventType.rawValue

        switch event.eventResult {
        case let .success(name, parameters):
            guard !eventType.shouldUseNameAsTitle else { return name }
            let title = parameters[eventType.eventKey] as? String
            return title ?? eventTypeValue
        case .failure:
            return eventTypeValue
        }
    }

    private func detail(event : LatiFlexEvents) -> String? {
        guard let eventType = Events(rawValue: event.eventType) else { return nil }

        switch event.eventResult {
        case let .success(_, parameters):
            guard let groupKey = eventType.groupKey else { return nil }
            return parameters[groupKey] as? String
        case .failure:
            return Constant.failedEventText
        }
    }
}

extension LatiFlexEventPresenter: LatiFlexEventsPresenterInterface {
    var numberOfItems: Int { 
        if !shouldShowGrouped() {
            return currentEventList.count
        }
        
        var count = 0
        for group in groupedEvents {
            count += 1 // Group header
            if group.count > 1 && group.isExpanded {
                count += group.events.count // Individual events
            }
        }
        return count
    }
    
    var isSummarizeSwitchEnabled: Bool {
        return isSummarizeEnabled
    }

    func viewDidLoad() {
        view?.prepareUI()
        filteredLatiFlexEvents = latiFlexEvents().filter { $0.eventType == LatiFlex.shared.eventTypes.first ?? Events.Adjust.rawValue }
        updateGroupedEvents()
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
        let items = LatiFlex.shared.eventTypes.map { $0 }
        view?.prepareSegmentedControl(items: items)
        view?.prepareEventListView()
        prepareSummarizeView()
        updateExpandCollapseButtonsVisibility()
    }

    func didSelectItem(at index: Int) {
        // Handle group expansion for grouped view
        if shouldShowGrouped() && isGroupHeader(at: index) {
            if let group = groupedEventForIndex(index), group.count > 1 {
                toggleGroupExpansion(at: index)
                return
            }
        }
        
        guard let eventResult = eventForIndex(index)?.eventResult else { return }
        switch eventResult {
        case let .success(_, parameters):
            router.presentEventDetail(eventParameters: summarizeEventIfNeeded(parameters: parameters), eventError: nil)
        case let .failure(error):
            router.presentEventDetail(eventParameters: nil, eventError: error)
        }
    }

    func item(at index: Int) -> LatiFlexEvents? {
        eventForIndex(index)
    }

    func arguments(at index: Int) -> LatiFlexCellPresenter.Arguments {
        if shouldShowGrouped() && isGroupHeader(at: index) {
            // Return grouped event data
            guard let group = groupedEventForIndex(index) else { return .init() }
            let titleText = group.count > 1 ? "\(group.title) (\(group.count))" : group.title
            return .init(title: titleText, detail: group.subtitle, isSuccess: group.isSuccess)
        }
        
        guard let event = item(at: index) else { return .init() }
        let title = title(event: event)
        let detail = detail(event: event)
        return .init(title: title, detail: detail, isSuccess: event.eventResult.isSuccess)
    }

    func selectedSegmentChanged(index: Int) {
        selectedIndex = index
        filteredLatiFlexEvents = latiFlexEvents().filter { $0.eventType == LatiFlex.shared.eventTypes[index] }
        searchedLatiFlexEvents = nil
        expandedGroups.removeAll() // Clear to trigger expand by default for new segment
        updateGroupedEvents()
        prepareSummarizeView()
        updateExpandCollapseButtonsVisibility()
        view?.setSearchBarText(text: "")
        view?.reloadData()
    }

    func textDidChange(searchtext: String) {
        guard !searchtext.isEmpty else {
            selectedSegmentChanged(index: selectedIndex)
            return
        }
        searchedLatiFlexEvents = filteredLatiFlexEvents.filter { checkEventContains(event: $0.eventResult, keyword: searchtext) }
        updateGroupedEvents()
        updateExpandCollapseButtonsVisibility()
        view?.reloadData()
    }
    
    func summarizeSwitchChanged(isOn: Bool) {
        isSummarizeEnabled = isOn
        UserDefaults.standard.set(isOn, forKey: Constant.summarizeSwitchUserDefaultKey)
        UserDefaults.standard.synchronize()
    }
}


extension LatiFlexEventPresenter {
    func prepareSummarizeView() {
        let eventType = LatiFlex.shared.eventTypes[selectedIndex]
        let isSummarizeVisible =  eventType == "Demeter" || eventType == "Delphoi"
        view?.setSummarizeStackViewVisibility(isHidden: !isSummarizeVisible)
    }
    
    func updateExpandCollapseButtonsVisibility() {
        // Show expand/collapse buttons only when there are grouped events
        let hasGroupedEvents = shouldShowGrouped()
        view?.setExpandCollapseButtonsVisibility(isHidden: !hasGroupedEvents)
    }
    
    func summarizeEventIfNeeded(parameters: [String: Any]) -> [String: Any] {
        guard isSummarizeSwitchEnabled else { return parameters }
        
        switch LatiFlex.shared.eventTypes[selectedIndex] {
        case "Demeter":
            return summarizeDemeterEvent(parameters: parameters)
        case "Delphoi":
            return summarizeDelphoiEvent(parameters: parameters)
        default:
            return parameters
        }
        
    }
    
    func summarizeDemeterEvent(parameters: [String: Any]) -> [String: Any] {
        return [
            "event": parameters["event"],
            "event_group": parameters["event_group"],
            "screen": parameters["screen"],
            "culture": parameters["culture"],
            "parameters": parameters["parameters"]
        ]
    }
    
    func summarizeDelphoiEvent(parameters: [String: Any]) -> [String: Any] {
        let removeableParameterKeys =  ["segment", "tv006", "tv123", "idfa", "device", "tv016", "appVersion", "tv015", "pid", "sid", "tv277", "channel", "screenSize", "tv037", "tv017", "tv008", "osVersion", "tv070", "tv245", "tv018", "tv278", "tv010"]
        var tempParameters = parameters
        removeableParameterKeys.forEach({ tempParameters.removeValue(forKey: $0)})
        return tempParameters
    }
    
    func shouldShowGrouped() -> Bool {
        // Show grouped view when there are repetitive events
        return groupedEvents.contains { $0.count > 1 }
    }
    
    func updateGroupedEvents() {
        var groups: [String: [LatiFlexEvents]] = [:]
        
        // Group events by title + subtitle
        for event in currentEventList {
            let title = title(event: event) ?? ""
            let subtitle = detail(event: event) ?? ""
            let key = "\(title)|\(subtitle)"
            
            if groups[key] == nil {
                groups[key] = []
            }
            groups[key]?.append(event)
        }
        
        // Convert to GroupedEvent array maintaining order
        groupedEvents = []
        var processedEvents = Set<ObjectIdentifier>()
        
        // If this is the first time, expand all groups by default
        let shouldExpandByDefault = expandedGroups.isEmpty && !groups.isEmpty
        
        for event in currentEventList {
            guard !processedEvents.contains(ObjectIdentifier(event as AnyObject)) else { continue }
            
            let title = title(event: event) ?? ""
            let subtitle = detail(event: event)
            let key = "\(title)|\(subtitle ?? "")"
            
            if let group = groups[key] {
                // Expand by default on first load if group has multiple items
                if shouldExpandByDefault && group.count > 1 {
                    expandedGroups.insert(key)
                }
                
                let isExpanded = expandedGroups.contains(key)
                let groupedEvent = GroupedEvent(title: title, subtitle: subtitle, events: group, isExpanded: isExpanded)
                groupedEvents.append(groupedEvent)
                
                // Mark all events in this group as processed
                for e in group {
                    processedEvents.insert(ObjectIdentifier(e as AnyObject))
                }
            }
        }
    }
    
    func toggleGroupExpansion(at index: Int) {
        guard let group = groupedEventForIndex(index) else { return }
        let key = "\(group.title)|\(group.subtitle ?? "")"
        
        if expandedGroups.contains(key) {
            expandedGroups.remove(key)
        } else {
            expandedGroups.insert(key)
        }
        
        // Don't call updateGroupedEvents here - just update the isExpanded flag
        for i in 0..<groupedEvents.count {
            if groupedEvents[i].title == group.title && groupedEvents[i].subtitle == group.subtitle {
                groupedEvents[i] = GroupedEvent(
                    title: groupedEvents[i].title,
                    subtitle: groupedEvents[i].subtitle,
                    events: groupedEvents[i].events,
                    isExpanded: expandedGroups.contains(key)
                )
                break
            }
        }
        
        view?.reloadData()
    }
    
    func groupedEventForIndex(_ index: Int) -> GroupedEvent? {
        guard shouldShowGrouped() else { return nil }
        
        var currentIndex = 0
        for (groupIndex, group) in groupedEvents.enumerated() {
            if currentIndex == index {
                return group
            }
            currentIndex += 1
            
            if group.count > 1 && group.isExpanded {
                currentIndex += group.events.count
            }
        }
        return nil
    }
    
    func eventForIndex(_ index: Int) -> LatiFlexEvents? {
        if !shouldShowGrouped() {
            return currentEventList[safe: index]
        }
        
        var currentIndex = 0
        for group in groupedEvents {
            if currentIndex == index {
                return group.events.first
            }
            currentIndex += 1
            
            if group.count > 1 && group.isExpanded {
                for (eventIdx, event) in group.events.enumerated() {
                    if currentIndex == index {
                        return event
                    }
                    currentIndex += 1
                }
            }
        }
        return nil
    }
    
    func isGroupHeader(at index: Int) -> Bool {
        guard shouldShowGrouped() else { return false }
        
        var currentIndex = 0
        for group in groupedEvents {
            if currentIndex == index {
                return true
            }
            currentIndex += 1
            
            if group.count > 1 && group.isExpanded {
                // Skip individual event indices
                if index < currentIndex + group.events.count {
                    return false // This is an individual event
                }
                currentIndex += group.events.count
            }
        }
        return false
    }
    
    func expandAll() {
        for group in groupedEvents where group.count > 1 {
            let key = "\(group.title)|\(group.subtitle ?? "")"
            expandedGroups.insert(key)
        }
        
        // Update isExpanded flag for all groups
        for i in 0..<groupedEvents.count {
            if groupedEvents[i].count > 1 {
                let key = "\(groupedEvents[i].title)|\(groupedEvents[i].subtitle ?? "")"
                groupedEvents[i] = GroupedEvent(
                    title: groupedEvents[i].title,
                    subtitle: groupedEvents[i].subtitle,
                    events: groupedEvents[i].events,
                    isExpanded: expandedGroups.contains(key)
                )
            }
        }
        
        view?.reloadData()
    }
    
    func collapseAll() {
        expandedGroups.removeAll()
        
        // Update isExpanded flag for all groups
        for i in 0..<groupedEvents.count {
            groupedEvents[i] = GroupedEvent(
                title: groupedEvents[i].title,
                subtitle: groupedEvents[i].subtitle,
                events: groupedEvents[i].events,
                isExpanded: false
            )
        }
        
        view?.reloadData()
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
