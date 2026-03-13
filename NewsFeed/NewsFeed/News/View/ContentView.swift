//
//  ContentView.swift
//  NewsFeed
//
//  Created by  Prince Shrivastav on 13/03/26.
//

import SwiftUI

struct ContentView: View {
    
    @State private var viewModel: NewsFeedViewModel = .init()
    
    var body: some View {
        NavigationStack {
            ZStack {
                switch viewModel.state {
                case .idle:
                    Color.clear
                case .loading:
                    ProgressView()
                case .success(let t):
                    ArticleList(articles: t)
                case .empty:
                    EmptyView()
                case .failure(let networkError):
                    ContentUnavailableView {
                        VStack {
                            Text("Network failure!")
                                .font(.system(size: 20, weight: .bold))
                            Text(networkError.localizedDescription)
                                .font(.system(size: 15, weight: .regular))
                                .padding(.bottom, 2)
                            Button {
                                Task {
                                    await viewModel.fetchNewsArticles()
                                }
                            } label: {
                                Text("Retry")
                                    .font(.system(size: 17, weight: .medium))
                            }
                            
                        }
                    }
                }
            }
            .task {
                await viewModel.fetchNewsArticles()
            }
        }
    }
}

#Preview {
    ContentView()
}
