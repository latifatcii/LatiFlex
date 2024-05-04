import UIKit

protocol LatiFlexInterface: AnyObject {}

public final class LatiFlex: LatiFlexInterface {
    public static let shared = LatiFlex()
    public var events: [LatiFlexEvents] = []
    public var configurations: [String: String] = [:]
    public var setConfigCompletion: ((String, String) -> ())?
    var networkingModel: [LatiFlexNetworkingModel] = []
    var deeplinkList: [DeeplinkList] = []
    
    var presenter: LatiFlexPresenterInterface!
    public var deeplinks: LatiFlexDeeplinksResponse?
    
    private init() {
        presenter = LatiFlexPresenter()
        URLProtocol.registerClass(LatiFlexURLProtocolListener.self)
    }
    
    public func inject(configuration: URLSessionConfiguration) {
        configuration.protocolClasses?.insert(LatiFlexURLProtocolListener.self, at: .zero)
    }
    
    public func setConfig(key: String, value: String) {
        setConfigCompletion?(key, value)
    }
    
    private let firstWindow = UIApplication.shared.windows.first
    
    public func show(items: [LatiFlexItemInterface] = []) {
        presenter.items = [LatiFlexEmptyItem()] + items + [LatiFlexDeeplinkItem(), LatiFlexEventsItem(), LatiFlexNetworkItem()]
        let floatyView = LAFloaty(frame: .init(x: .zero, y: .zero, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        
        var rootHasFloatyView: Bool = false
        firstWindow?.subviews.forEach {
            if $0 is LAFloaty {
                rootHasFloatyView = true
                $0.removeFromSuperview()
                return
            }
        }
        if !rootHasFloatyView {
            firstWindow?.addSubview(floatyView)
            floatyView.datasource = self
        }
    }
    
    public func appendEvents(type: String, name: String?, parameters: [String : String]) {
        let event = LatiFlexEvents(
            eventType: type,
            name: name,
            parameters: parameters
        )
        LatiFlex.shared.events.append(event)
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
