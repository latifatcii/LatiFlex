import Foundation

public class LatiFlexURLProtocol: URLProtocol {
    private var dataTask: URLSessionDataTask?
    private static let queue = DispatchQueue(label: "com.latiflex.urlprotocol", qos: .userInitiated)
    private var networkingModel: LatiFlexNetworkingModel!
    
    private lazy var session: URLSession = {
        let config = URLSessionConfiguration.ephemeral
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        return URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }()
    
    public override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    public override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    public override func startLoading() {
        networkingModel = LatiFlexNetworkingModel()
        networkingModel.request = request
        networkingModel.startTime = Date()
        
        Self.queue.async { [weak self] in
            guard let self = self else { return }
            
            if let mockResponse = LatiFlexNetworkInterceptor.shared.shouldUseMockResponse(for: self.request.url!) {
                self.handleMockResponse(mockResponse)
                return
            }
            
            self.dataTask = self.session.dataTask(with: self.request) { [weak self] data, response, error in
                guard let self = self else { return }
                
                if let error = error {
                    self.client?.urlProtocol(self, didFailWithError: error)
                    return
                }
                
                if let response = response {
                    self.networkingModel.update(with: response)
                    self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                }
                
                if let data = data {
                    self.networkingModel.data.append(data)
                    self.client?.urlProtocol(self, didLoad: data)
                }
                
                self.client?.urlProtocolDidFinishLoading(self)
                LatiFlex.shared.networkingModel.append(self.networkingModel)
            }
            
            self.dataTask?.resume()
        }
    }
    
    public override func stopLoading() {
        Self.queue.async {
            self.dataTask?.cancel()
        }
    }
    
    private func handleMockResponse(_ mockResponse: String) {
        guard let data = mockResponse.data(using: .utf8),
              let url = request.url else {
            return
        }
        
        let response = HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: "HTTP/1.1",
            headerFields: ["Content-Type": "application/json"]
        )
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if let response = response {
                self.networkingModel.update(with: response)
                self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            
            self.networkingModel.data = data
            self.client?.urlProtocol(self, didLoad: data)
            self.client?.urlProtocolDidFinishLoading(self)
            
            LatiFlex.shared.networkingModel.append(self.networkingModel)
        }
    }
}

extension LatiFlexURLProtocol: URLSessionDataDelegate {
    public func urlSession(_ session: URLSession,
                          dataTask: URLSessionDataTask,
                          didReceive response: URLResponse,
                          completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        networkingModel.update(with: response)
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        completionHandler(.allow)
    }
    
    public func urlSession(_ session: URLSession,
                          dataTask: URLSessionDataTask,
                          didReceive data: Data) {
        networkingModel.data.append(data)
        client?.urlProtocol(self, didLoad: data)
    }
    
    public func urlSession(_ session: URLSession,
                          task: URLSessionTask,
                          didCompleteWithError error: Error?) {
        if let error = error {
            client?.urlProtocol(self, didFailWithError: error)
        } else {
            client?.urlProtocolDidFinishLoading(self)
        }
        
        LatiFlex.shared.networkingModel.append(networkingModel)
    }
} 