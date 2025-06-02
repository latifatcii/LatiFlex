import Foundation

public protocol LatiFlexURLProtocolListenerDelegate: AnyObject {
    func didReceiveResponse(_ response: URLResponse, data: Data)
    func didReceiveData(_ data: Data)
    func didComplete(withError error: Error?)
}

public class LatiFlexURLProtocolListener: NSObject {
    public weak var delegate: LatiFlexURLProtocolListenerDelegate?
    private var data = Data()
    
    public func urlProtocol(_ protocol: URLProtocol, didReceive response: URLResponse, cacheStoragePolicy: URLCache.StoragePolicy) {
        delegate?.didReceiveResponse(response, data: data)
    }
    
    public func urlProtocol(_ protocol: URLProtocol, didLoad data: Data) {
        self.data.append(data)
        delegate?.didReceiveData(data)
    }
    
    public func urlProtocolDidFinishLoading(_ protocol: URLProtocol) {
        delegate?.didComplete(withError: nil)
    }
    
    public func urlProtocol(_ protocol: URLProtocol, didFailWithError error: Error) {
        delegate?.didComplete(withError: error)
    }
} 