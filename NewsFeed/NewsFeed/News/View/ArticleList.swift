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
    @Namespace private var namespace
    var body: some View {
        GeometryReader { proxy in
            List(articles) { row in
                ZStack(alignment: .leading) {
                    NavigationLink {
                        NewsDetailView(article: row)
                    } label: {
                        EmptyView()  // hides the default link UI entirely
                    }
                    .opacity(0)
                   ArticleView(article: row, width: proxy.size.width)
                }
                .listRowSeparator(.hidden)
                .listRowSpacing(15)
                .onAppear {
                    viewModel.loadNextPage(row.id)
                }
            }
            .listRowInsets(.init())
            .listStyle(.plain)
            .navigationTitle("News")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    NavigationStack {
        ArticleList(articles: [Article.defaultItem],
                    viewModel: .init())
    }
}
