//
//  MainViewModel.swift
//  SampleProject
//
//  Created by Banu on 20.08.2024.
//

import Foundation

protocol MainViewModelProtocol {
    var delegate: MainViewModelDelegate? { get set }
    
    func tappedForRequest()
    func tappedForBreakingNews()
}

protocol MainViewModelDelegate: AnyObject {
    
}

class MainViewModel {
    weak var delegate: MainViewModelDelegate?
    var articles: [Article]?
    var breakingNews: [Article]?
    
    func fetchArticles() {
        NetworkManager.shared.getArticles { responseData in
            switch responseData {
            case .success(let responseData):
                self.articles = responseData.articles
                print(responseData)
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    func fetchBreakingNews() {
        NetworkManager.shared.getBreakingNews { responseData in
            switch responseData {
            case .success(let responseData):
                self.breakingNews = responseData.articles
                print(responseData)
                break
            case .failure(let error):
                print(error)
                break
            }
        }
        
        NetworkManager.shared.postArticle(data: articleData) { responseData in
            switch responseData {
            case .success(let responseData):
                self.breakingNews = responseData.articles
                print(responseData)
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    let articleData: [String: Any] = [
        "title": "Breaking News: Swift is awesome!",
        "description": "In this article, we discuss why Swift is such a powerful and modern programming language.",
        "author": "John Doe",
        "publishedAt": "2024-09-14T10:00:00Z",
        "source": [
            "id": "swift-news",
            "name": "Swift News"
        ],
        "url": "https://example.com/swift-news",
        "content": "Here is the full content of the article..."
    ]

}

extension MainViewModel: MainViewModelProtocol {
    func tappedForBreakingNews() {
        fetchBreakingNews()
    }
    
    func tappedForRequest() {
        fetchArticles()
    }
    
    
}
