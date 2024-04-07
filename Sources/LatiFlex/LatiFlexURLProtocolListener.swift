//
//  LatiFlexURLProtocolListener.swift
//
//
//  Created by Abdüllatif Atçı on 16.03.2024.
//

import Foundation

public class LatiFlexURLProtocolListener: URLProtocol {
    private var networkingModel: LatiFlexNetworkingModel = .init()
    
    private lazy var session: URLSession = { [unowned self] in
        return URLSession(configuration: .default, delegate: self, delegateQueue: nil)
    }()
    
    public override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    public override func startLoading() {
        networkingModel.request = request
        networkingModel.startTime = Date()
        guard let mutableRequest = (request as NSURLRequest).mutableCopy() as? NSMutableURLRequest else {
            session.dataTask(with: request).resume()
            return
        }
        session.dataTask(with: mutableRequest as URLRequest).resume()
    }
    
    public override func stopLoading() {
        LatiFlex.shared.networkingModel.append(networkingModel)
        session.getTasksWithCompletionHandler { dataTasks, _, _ in
            dataTasks.forEach { $0.cancel() }
            self.session.invalidateAndCancel()
        }
    }
    
    public override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }
}

extension LatiFlexURLProtocolListener: URLSessionDataDelegate {
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        networkingModel.data.append(data)
        client?.urlProtocol(self, didLoad: data)
    }

    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        
        networkingModel.update(with: response)
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        completionHandler(.allow)
    }

    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            client?.urlProtocol(self, didFailWithError: error)
        } else {
            client?.urlProtocolDidFinishLoading(self)
        }
    }

    public func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        client?.urlProtocol(self, wasRedirectedTo: request, redirectResponse: response)
        completionHandler(request)
    }

    public func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        client?.urlProtocolDidFinishLoading(self)
    }
}

