//
//  NetworkManager.swift
//  SampleProject
//
//  Created by Banu on 20.08.2024.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func request<T:Decodable> (_ endpoint : Endpoint, completion : @escaping (Swift.Result  <T, Error>) ->Void) ->Void {
        
        let urlSessionTask = URLSession.shared.dataTask(with: endpoint.request()) {(data ,response , error) in
            if let error = error {
                print(error)
            }
            if let response = response as? HTTPURLResponse {}
            
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
        let endpoint = Endpoint.articles(query: "&apiKey=3981648866734d75902b4b10fc53ff322")
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
