//
//  NewsFeedViewModel.swift
//  NewsFeed
//
//  Created by  Prince Shrivastav on 13/03/26.
//

import SwiftUI

@Observable
@MainActor
final class NewsFeedViewModel {
    
    var state: ViewState<[Article]> = .idle
    private var pageNumber: Int = 1
    private var paginationTask: Task<Void, Never>?
    private(set) var pagenationErrorMessage: String?
    private var isLoadingNextPage = false
    private var hasMorePages = true
    private var refreshTask: Task<Void, Never>?
    
    let repository: NewsArticleRepository
    init(repository: NewsArticleRepository) {
        self.repository = repository
    }
    
    convenience init() {
        self.init(repository: NewsArticleRequestRepositry())
    }
    
    func fetchNewsArticles() async {
        state = .loading
        await performFetchNews()
    }
    
    func cancel() {
        paginationTask?.cancel()
        paginationTask = nil
        refreshTask?.cancel()
        refreshTask = nil
    }
}
// MARK: - Private method
private extension NewsFeedViewModel {
    
    func performFetchNews() async {
        do {
            let result = try await repository.getNewArticles(page: pageNumber)
            try Task.checkCancellation()
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
// MARK: - Refresh
extension NewsFeedViewModel {
    func refresh() async {
        resetPaginationState()
        refreshTask?.cancel()
        refreshTask = Task { [weak self] in
            await self?.performFetchNews()
        }
        await refreshTask?.value
    }
    
}
// MARK: - Pagination
extension NewsFeedViewModel {
    func loadNextPage(_ id: UUID) {
        guard !isLoadingNextPage, hasMorePages else { return }
        guard case let .success(currentArticles) = state, currentArticles.last?.id == id else { return }
        let nextPage = pageNumber + 1
        paginationTask = Task { [weak self] in
            guard let self else { return }
            do {
                defer { self.isLoadingNextPage = false }
                self.isLoadingNextPage = true
                let result = try await self.repository.getNewArticles(page: nextPage)
                try Task.checkCancellation()
                if result.status == "ok" {
                    guard !result.articles.isEmpty else {
                        self.hasMorePages = false
                        return
                    }
                    
                    let newItems = result.articles.filter { newItem in
                        currentArticles.contains(where: { $0.id == newItem.id }) == false
                    }
                    let merged = currentArticles + newItems
                    self.state = .success(merged)
                    self.pageNumber = nextPage
                } else {
                    self.pagenationErrorMessage = result.status
                }
            }  catch is CancellationError {
                /// ignore
            } catch let error as NetworkError {
                self.pagenationErrorMessage = error.localizedDescription
            } catch {
                self.pagenationErrorMessage = error.localizedDescription
            }
            
        }
    }
    
    private func resetPaginationState() {
        paginationTask?.cancel()
        paginationTask = nil
        pageNumber = 1
        hasMorePages = true
        isLoadingNextPage = false
        pagenationErrorMessage = nil
    }
}
