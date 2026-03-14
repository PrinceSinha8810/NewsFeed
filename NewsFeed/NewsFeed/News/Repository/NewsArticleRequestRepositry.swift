//
//  NewsArticleRequestRepositry.swift
//  NewsFeed
//
//  Created by  Prince Shrivastav on 13/03/26.
//

import Foundation

protocol NewsArticleRepository {
    func getNewArticles(page number: Int) async throws -> NewsResponse
}

final class NewsArticleRequestRepositry: NewsArticleRepository {
    
    let networkManager: NetworkBuilder
    let pageItemLimit: Int = 20
    init(networkManager: NetworkBuilder = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func getNewArticles(page number: Int) async throws -> NewsResponse {
        try await networkManager.fetchRequest(for: NewsArticleEndpoint.articles(pageNumber: number, limit: pageItemLimit))
    }
}
