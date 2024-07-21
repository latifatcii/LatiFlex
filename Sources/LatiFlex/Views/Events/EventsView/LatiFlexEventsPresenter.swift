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
    
    func viewDidLoad()
    func didSelectItemAt(index: Int)
    func itemAt(index: Int) -> LatiFlexEvents?
    func eventNameAt(index: Int) -> String?
    func selectedSegmentChanged(index: Int)
    func textDidChange(searchtext: String)
}

private extension LatiFlexEventPresenter {
    enum Constant {
        static let closeButtonImage: String = "DebuggerKitCloseButtonIcon"
        static let deleteIconImage: String = "DebuggerKitDeleteButtonIcon"
        static let eventParameterName: String = "event"
        static let firebaseCategoryParameterName: String = "eventCategory"
    }
    
    enum Events: String, CaseIterable {
        case Adjust
        case Delphoi
        case Demeter
        case Firebase
        case NewRelic
    }
}

final class LatiFlexEventPresenter {
    private weak var view: LatiFlexEventsViewInterface?
    private let router: LatiFlexEventsRouterInterface
    private var latiFlexEvents: () -> [LatiFlexEvents]
    private var filteredLatiFlexEvents: [LatiFlexEvents] = []
    private var removeLatiFlexEvents: ([LatiFlexEvents]) -> ()
    private var selectedIndex: Int = .zero
    
    init(view: LatiFlexEventsViewInterface?,
         router: LatiFlexEventsRouterInterface,
         latiFlexEvents: @escaping () -> [LatiFlexEvents] = { LatiFlex.shared.events.reversed() },
         removeLatiFlexEvents: @escaping ([LatiFlexEvents]) -> () = { LatiFlex.shared.events = $0 }) {
        self.view = view
        self.router = router
        self.latiFlexEvents = latiFlexEvents
        self.removeLatiFlexEvents = removeLatiFlexEvents
    }
    
    @objc private func closeButtonTapped() {
        router.dismissModule(animated: true)
    }
    
    @objc private func deleteButtonTapped() {
        removeLatiFlexEvents([])
        filteredLatiFlexEvents = latiFlexEvents().filter { $0.eventType == LatiFlex.shared.eventTypes[selectedIndex] }
        view?.reloadData()
    }
}

extension LatiFlexEventPresenter: LatiFlexEventsPresenterInterface {
    var numberOfItems: Int { filteredLatiFlexEvents.count }
    
    func viewDidLoad() {
        view?.prepareUI()
        filteredLatiFlexEvents = latiFlexEvents().filter { $0.eventType == Events.Adjust.rawValue }
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
    }
    
    func didSelectItemAt(index: Int) {
        router.presentEventDetail(eventParameters: itemAt(index: index)?.parameters)
    }
    
    func itemAt(index: Int) -> LatiFlexEvents? {
        filteredLatiFlexEvents[index]
    }
    
    func eventNameAt(index: Int) -> String? {
        switch filteredLatiFlexEvents[index].eventType {
        case Events.Firebase.rawValue:
            guard let eventName = filteredLatiFlexEvents[index].parameters[Constant.firebaseCategoryParameterName] else { return nil }
            return eventName
        case Events.Demeter.rawValue:
            return filteredLatiFlexEvents[index].name
        default:
            guard let eventName = filteredLatiFlexEvents[index].parameters[Constant.eventParameterName] else { return nil }
            return eventName
        }
    }
    
    func selectedSegmentChanged(index: Int) {
        selectedIndex = index
        filteredLatiFlexEvents = latiFlexEvents().filter { $0.eventType == Events.allCases[index].rawValue }
        view?.reloadData()
    }
    
    func textDidChange(searchtext: String) {
        guard !searchtext.isEmpty else {
            selectedSegmentChanged(index: selectedIndex)
            return
        }
        filteredLatiFlexEvents = latiFlexEvents().filter { $0.parameters.keys.contains(searchtext) }
        view?.reloadData()
    }
}
