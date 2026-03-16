//
//  ContentView.swift
//  NewsFeed
//
//  Created by  Prince Shrivastav on 13/03/26.
//

import SwiftUI
@MainActor
struct ContentView: View {
    
    @State private var viewModel: NewsFeedViewModel = .init()
    
    var body: some View {
        NavigationStack {
            ZStack {
                ArticleList(viewModel: viewModel)
                if case let .failure(error) = viewModel.state {
                    ContentUnavailableView {
                        VStack {
                            Text("Network failure!")
                                .font(.system(size: 20, weight: .bold))
                            Text(error.localizedDescription)
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
            .onDisappear {
                viewModel.cancel()
            }
        }
    }
}

#Preview {
    ContentView()
}
