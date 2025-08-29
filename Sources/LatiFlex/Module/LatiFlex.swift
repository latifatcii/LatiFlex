import UIKit

protocol LatiFlexInterface: AnyObject {}

public final class LatiFlex: LatiFlexInterface {
    public static let shared = LatiFlex()
    public var events: [LatiFlexEvents] = []
    public var eventTypes: [String] = []
    public var configurations: [String: String] = [:]
    public var setConfigCompletion: ((String, String) -> ())?
    public var networkRequestCallback: ((LatiFlexNetworkingModel) -> Void)?
    var networkingModel: [LatiFlexNetworkingModel] = []
    var deeplinkList: [DeeplinkList] = []
    
    var presenter: LatiFlexPresenterInterface!
    public var deeplinks: LatiFlexDeeplinksResponse?
    
    private init() {
        presenter = LatiFlexPresenter()
        setupNetworkMocking()
    }
    
    public func inject(configuration: URLSessionConfiguration) {
        // Önce mevcut protocol class'ları temizle
        configuration.protocolClasses = configuration.protocolClasses?.filter { $0 != LatiFlexURLProtocol.self }
        
        // Sonra ekle
        var protocolClasses = configuration.protocolClasses ?? []
        protocolClasses.insert(LatiFlexURLProtocol.self, at: 0)
        configuration.protocolClasses = protocolClasses
    }
    
    public func setConfig(key: String, value: String) {
        setConfigCompletion?(key, value)
    }
    
    private var activeWindow: UIWindow? {
        // First try the key window via modern scene-based API (iOS 13+)
        if let keyWindow = UIApplication.shared
            .connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow }) {
            return keyWindow
        }

        // Fallback: Use deprecated API (for older apps or simple previews)
        return UIApplication.shared.windows.first
    }

    public func show(items: [LatiFlexItemInterface] = []) {
        presenter.items = [LatiFlexEmptyItem()] + items + [LatiFlexDeeplinkItem(), LatiFlexEventsItem(), LatiFlexNetworkItem()]
        
        guard let window = activeWindow else {
            print("⚠️ LatiFlexWrapper: No window found to attach floaty view.")
            return
        }

        // Avoid duplicates
        for subview in window.subviews where subview is LAFloaty {
            subview.removeFromSuperview()
            return
        }

        let floatyView = LAFloaty(frame: window.bounds)
        window.addSubview(floatyView)
        window.bringSubviewToFront(floatyView)
        floatyView.datasource = self
    }
    
    public func appendEvents(type: String, eventResult: LatiFlexEventResult) {
        let event = LatiFlexEvents(
            eventType: type,
            eventResult: eventResult
        )
        LatiFlex.shared.events.append(event)
    }
    
    public func appendEventTypes(type: String) {
        LatiFlex.shared.eventTypes.append(type)
    }
    
    // MARK: - Network Monitoring
    
    public func setNetworkRequestCallback(_ callback: @escaping (LatiFlexNetworkingModel) -> Void) {
        self.networkRequestCallback = callback
    }
    
    // Internal method to notify about new network requests
    internal func notifyNetworkRequest(_ model: LatiFlexNetworkingModel) {
        networkRequestCallback?(model)
    }
    
    private func setupNetworkMocking() {
        URLProtocol.registerClass(LatiFlexURLProtocol.self)
    }
}

extension LatiFlex: LAFloatyViewDatasource {
    public var itemCount: Int {
        presenter.itemCount
    }
    
    public func itemImage(at index: Int) -> UIImage? {
        presenter.itemAt(index: index)?.image
    }
    
    public func didSelectItem(at index: Int) {
        presenter.didSelectItemAt(index: index, deeplinks: deeplinks)
    }
}
