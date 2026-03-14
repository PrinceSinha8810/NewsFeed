//
//  ArticleList.swift
//  NewsFeed
//
//  Created by  Prince Shrivastav on 14/03/26.
//

import SwiftUI

struct ArticleList: View {
    let articles: [Article]
    let viewModel: NewsFeedViewModel
    var body: some View {
        GeometryReader { proxy in
            List(articles) { row in
                ArticleView(article: row, width: proxy.size.width)
                    .listRowInsets(.init())
                    .listRowSeparator(.hidden)
                    .onAppear {
                        viewModel.loadNextPage(row.id)
                    }
            }
            .listStyle(.plain)
            .listRowSpacing(25)
            .navigationTitle("News")
            .navigationBarTitleDisplayMode(.inline)
            .refreshable {
                await viewModel.refresh()
            }
        }
    }
}

#Preview {
    ArticleList(articles: [Article.defaultItem],
                viewModel: .init())
}
