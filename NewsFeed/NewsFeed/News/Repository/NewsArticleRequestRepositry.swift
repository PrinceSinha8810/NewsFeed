//
//  NewsArticleRequestRepositry.swift
//  NewsFeed
//
//  Created by  Prince Shrivastav on 13/03/26.
//

import Foundation

protocol NewsArticleRepository {
    func getNewArticles() async throws -> NewsResponse
}

final class NewsArticleRequestRepositry: NewsArticleRepository {
    
    let networkManager: NetworkBuilder
    
    init(networkManager: NetworkBuilder = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func getNewArticles() async throws -> NewsResponse {
        try await networkManager.fetchRequest(for: NewsArticleEndpoint.articles(pageNumber: 1, limit: 20))
    }
}
