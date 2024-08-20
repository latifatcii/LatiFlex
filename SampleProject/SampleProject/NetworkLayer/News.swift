//
//  News.swift
//  SampleProject
//
//  Created by Banu on 20.08.2024.
//

import Foundation

// MARK: - Welcome
struct Welcome: Decodable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

// MARK: - Article
struct Article: Decodable {
    let source: Source
    let author: String?
    let title, description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
}

// MARK: - Source
struct Source: Decodable {
    let id: String?
    let name: String
}
