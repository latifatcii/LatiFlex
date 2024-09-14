//
//  Endpoint.swift
//  SampleProject
//
//  Created by Banu on 20.08.2024.
//

import Foundation

enum Endpoint {
    case articles(query: String)
    case breakingNews(query: String)
    case postArticle(data: [String: Any]) // Example POST request
}

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
}

protocol EndpointProtocol {
    var baseUrl: String {get}
    var path: String {get}
    var method: HttpMethod {get}
    var httpBody: Data? {get} // Optional for requests with bodies
    func request() -> URLRequest
}

extension Endpoint: EndpointProtocol {
    var baseUrl: String {
        switch self {
        case .articles, .breakingNews, .postArticle:
            return "https://newsapi.org/v2/"
        }
    }
    
    var path: String {
        switch self {
        case .articles(let query):
            return "everything?q=keyword\(query)"
        case .breakingNews(let query):
            return "top-headlines?country=us\(query)"
        case .postArticle:
            return "articles"
        }
    }
    
    var method: HttpMethod {
        switch self {
        case .articles, .breakingNews: return .get
        case .postArticle: return .post
        }
    }
    
    var httpBody: Data? {
        switch self {
        case .postArticle(let data):
            return try? JSONSerialization.data(withJSONObject: data, options: [])
        default:
            return nil
        }
    }
    
    func request() -> URLRequest {
        guard let url = URL(string: baseUrl + path) else {
            fatalError("Invalid URL")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let body = httpBody {
            request.httpBody = body
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        return request
    }
}
