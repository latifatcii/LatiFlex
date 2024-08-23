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
    }
}

extension MainViewModel: MainViewModelProtocol {
    func tappedForBreakingNews() {
        fetchBreakingNews()
    }
    
    func tappedForRequest() {
        fetchArticles()
    }
    
    
}
