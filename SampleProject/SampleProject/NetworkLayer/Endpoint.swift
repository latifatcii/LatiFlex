//
//  Endpoint.swift
//  SampleProject
//
//  Created by Banu on 20.08.2024.
//

import Foundation

enum Endpoint {
    case articles(query: String)
}

enum HttpMethod: String {
    case get = "GET"
}

protocol EndpointProtocol {
    var baseUrl: String {get}
    var path : String {get}
    func request () -> URLRequest
}

extension Endpoint: EndpointProtocol {
    var baseUrl: String {
        switch self {
        case .articles(let query):
            return "https://newsapi.org/v2/"
        }
    }
    
    var path: String {
        switch self {
        case .articles(let query):
            return "everything?q=keyword\(query)"
        }
    }
    
    var method: HttpMethod {
        switch self {
        case .articles: return .get
    }
}
    
    func request() -> URLRequest {
        guard var component = URLComponents(string: baseUrl) else {
            fatalError("Invalid Error")
        }
        component.path = path
        var request = URLRequest(url: URL(string: baseUrl+path)!)
        request.httpMethod = method.rawValue
        
        return request
    }
}
