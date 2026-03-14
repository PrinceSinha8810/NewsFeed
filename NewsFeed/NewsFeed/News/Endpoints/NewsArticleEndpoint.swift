//
//  NewsArticleEndpoint.swift
//  NewsFeed
//
//  Created by  Prince Shrivastav on 13/03/26.
//

import Foundation

// MARK: - Get API key
enum AppSecretsKey {
    static var apiKeys: String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String, !key.isEmpty, !key.contains("$(") else {
            fatalError("Missing API_KEY")
        }
        return key
    }
}

enum NewsArticleEndpoint: Endpoint {
        
    case articles(pageNumber: Int, limit: Int)
    
    var baseURL: URL {
        URL(string: "https://newsapi.org")!
    }
    var path: String {
        return "/v2/everything"
    }
    var method: HttpMethod {
        .get
    }
    
    private var apiKey: String {
        return AppSecretsKey.apiKeys
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .articles(let page, let limit):
            [.init(name: "q", value: "Sports"),
             .init(name: "apiKey", value: apiKey),
             .init(name: "pageSize", value: "\(limit)"),
             .init(name: "page", value: "\(page)")]
        }
    }
    
}
