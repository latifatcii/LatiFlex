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
    var numberOfItems: Int { currentEventList.count }
    
    var isSummarizeSwitchEnabled: Bool {
        return isSummarizeEnabled
    }

    func viewDidLoad() {
        view?.prepareUI()
        filteredLatiFlexEvents = latiFlexEvents().filter { $0.eventType == LatiFlex.shared.eventTypes.first ?? Events.Adjust.rawValue }
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
    }

    func didSelectItem(at index: Int) {
        guard let eventResult = item(at: index)?.eventResult else { return }
        switch eventResult {
        case let .success(_, parameters):
            router.presentEventDetail(eventParameters: summarizeEventIfNeeded(parameters: parameters), eventError: nil)
        case let .failure(error):
            router.presentEventDetail(eventParameters: nil, eventError: error)
        }
    }

    func item(at index: Int) -> LatiFlexEvents? {
        currentEventList[index]
    }

    func arguments(at index: Int) -> LatiFlexCellPresenter.Arguments {
        guard let event = item(at: index) else { return .init() }
        let title = title(event: event)
        let detail = detail(event: event)
        return .init(title: title, detail: detail, isSuccess: event.eventResult.isSuccess)
    }

    func selectedSegmentChanged(index: Int) {
        selectedIndex = index
        filteredLatiFlexEvents = latiFlexEvents().filter { $0.eventType == LatiFlex.shared.eventTypes[index] }
        searchedLatiFlexEvents = nil
        prepareSummarizeView()
        view?.setSearchBarText(text: "")
        view?.reloadData()
    }

    func textDidChange(searchtext: String) {
        guard !searchtext.isEmpty else {
            selectedSegmentChanged(index: selectedIndex)
            return
        }
        searchedLatiFlexEvents = currentEventList.filter { checkEventContains(event: $0.eventResult, keyword: searchtext) }
        view?.reloadData()
    }
    
    func summarizeSwitchChanged(isOn: Bool) {
        isSummarizeEnabled = isOn
        UserDefaults.standard.set(isOn, forKey: Constant.summarizeSwitchUserDefaultKey)
        UserDefaults.standard.synchronize()
    }
}


private extension LatiFlexEventPresenter {
    func prepareSummarizeView() {
        let eventType = LatiFlex.shared.eventTypes[selectedIndex]
        let isSummarizeVisible =  eventType == "Demeter" || eventType == "Delphoi"
        view?.setSummarizeStackViewVisibility(isHidden: !isSummarizeVisible)
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
}
