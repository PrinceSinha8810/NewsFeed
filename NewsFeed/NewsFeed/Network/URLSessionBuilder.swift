//
//  URLSessionBuilder.swift
//  NewsFeed
//
//  Created by  Prince Shrivastav on 13/03/26.
//

import Foundation

protocol URLSessionBuilder {
    func perform(url request: URLRequest) async throws -> (Data, URLResponse)
}

final class URLSessionBuilderManager: URLSessionBuilder {
    
    private let session: URLSession
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func perform(url request: URLRequest) async throws -> (Data, URLResponse) {
        try await session.data(for: request)
    }
}
