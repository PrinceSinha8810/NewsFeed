//
//  NewsFeedViewModel.swift
//  NewsFeed
//
//  Created by  Prince Shrivastav on 13/03/26.
//

import SwiftUI

@Observable
final class NewsFeedViewModel {
    
    var state: ViewState<[Article]> = .idle
    
    let repository: NewsArticleRepository
    
    init(repository: NewsArticleRepository = NewsArticleRequestRepositry()) {
        self.repository = repository
    }
    
    func fetchNewsArticles() async {
        state = .loading
        do {
            let result = try await repository.getNewArticles()
            if result.status == "ok" {
                if result.articles.isEmpty {
                    state = .empty
                } else {
                    state = .success(result.articles)
                }
            } else {
                state = .failure(.message(result.status))
            }
            
        } catch is CancellationError {
           /// ignore
        } catch let error as NetworkError {
            state = .failure(error)
        } catch {
            state = .failure(NetworkError.underlying(error))
        }
    }
    
}
