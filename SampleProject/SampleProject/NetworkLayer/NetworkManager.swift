//
//  NetworkManager.swift
//  SampleProject
//
//  Created by Banu on 20.08.2024.
//

import Foundation
import LatiFlex

class NetworkManager {
    static let shared = NetworkManager()
    
    private let session: URLSession
    
    private init() {
        let configuration = URLSessionConfiguration.default
        LatiFlex.shared.inject(configuration: configuration)
        session = URLSession(configuration: configuration)
    }
    
    func request<T:Decodable> (_ endpoint : Endpoint, completion : @escaping (Swift.Result  <T, Error>) ->Void) ->Void {
        let urlSessionTask = session.dataTask(with: endpoint.request()) {(data ,response , error) in
            if let error = error {
                print(error)
                completion(.failure(error))
                return
            }
            
            if let data = data {
                do {
                    let jsonData = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(jsonData))
                    
                }catch let error {
                    completion(.failure(error))
                }
            }
        }
        urlSessionTask.resume()
    }
    
    func getArticles (completion: @escaping (Swift.Result<Welcome , Error>) ->Void) -> Void {
        let endpoint = Endpoint.articles(query: "&apiKey=3981648866734d75902b4b10fc53ff32")
        request(endpoint, completion: completion)
    }
    
    func getBreakingNews (completion: @escaping (Swift.Result<Welcome , Error>) ->Void) -> Void {
        let endpoint = Endpoint.breakingNews(query: "&apiKey=3981648866734d75902b4b10fc53ff32")
        request(endpoint, completion: completion)
    }
    
    func postArticle(data: [String: Any], completion: @escaping (Swift.Result<Welcome, Error>) -> Void) -> Void {
        let endpoint = Endpoint.postArticle(data: data)
        request(endpoint, completion: completion)
    }
}
