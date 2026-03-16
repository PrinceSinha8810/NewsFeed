//
//  ArticleList.swift
//  NewsFeed
//
//  Created by  Prince Shrivastav on 14/03/26.
//

import SwiftUI

struct ArticleList: View {
    let viewModel: NewsFeedViewModel
    @Namespace private var namespace
    @State private var navigationTitle = "News"
    @State private var showStickyCategories = false
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                /// All Articles
                Section {
                    allArticles(width: proxy.size.width)
                } header: {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("All Articles")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.system(size: 18, weight: .bold))
                            .padding(.horizontal, 10)
                        categoriesScroll
                    }
                    .background(headerOffsetListener)
                }
            }
            .coordinateSpace(name: "ArticleListScroll")
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(navigationTitle)
            .safeAreaInset(edge: .top) {
                if showStickyCategories {
                    categoriesScroll
                        .padding(.top, 4)
                        .padding(.bottom, 6)
                        .background(.thinMaterial)
                        .shadow(color: .black.opacity(0.08), radius: 6, y: 3)
                }
            }
        }
    }
    
    // MARK: - All Article
    @ViewBuilder
    func allArticles(width: CGFloat) -> some View {
        LazyVStack(alignment: .leading, spacing: 30) {
            if case .loading = viewModel.state {
                ForEach(0..<8) { _ in
                    ArticleView(width: width,
                                state: .loading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            } else if let article = viewModel.state.getItem {
                ForEach(article) { row in
                    NavigationLink {
                        NewsDetailView(article: row)
                    } label: {
                        ArticleView(width: width,
                                    state: .success(row))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .buttonStyle(.plain)
                    .onAppear {
                        viewModel.loadNextPage(row.id)
                    }
                }
            }
            
        }
    }
    
    /// Listens for header position to swap navigation title once it scrolls beneath the nav bar.
    private var headerOffsetListener: some View {
        GeometryReader { geo in
            Color.clear
                .preference(key: HeaderOffsetKey.self,
                            value: geo.frame(in: .named("ArticleListScroll")).minY)
        }
        .onPreferenceChange(HeaderOffsetKey.self) { offset in
            navigationTitle = offset < 0 ? "All Articles" : "News"
            showStickyCategories = offset < 0
        }
    }
    
    /// Horizontally scrollable category chips that stay pinned with the header.
    private var categoriesScroll: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(viewModel.categories, id: \.self) { category in
                    Text(category)
                        .font(.system(size: 14, weight: .semibold))
                        .padding(.vertical, 8)
                        .padding(.horizontal, 14)
                        .background(viewModel.selectedCategory == category ? Color.blue.opacity(0.15) : Color.gray.opacity(0.15))
                        .foregroundColor(viewModel.selectedCategory == category ? .blue : .primary)
                        .clipShape(Capsule())
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                viewModel.selectCategory(category)
                            }
                        }
                }
            }
            .padding(.horizontal, 10)
            .padding(.bottom, 8)
        }
    }
}

private struct HeaderOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
#Preview {
    NavigationStack {
        ArticleList(viewModel: .init())
    }
}
