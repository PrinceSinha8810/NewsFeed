//
//  ArticleView.swift
//  NewsFeed
//
//  Created by  Prince Shrivastav on 14/03/26.
//

import SwiftUI

struct ArticleView: View {
    let article: Article
    let width: CGFloat
    var body: some View {
            VStack {
                AsyncImage(url: article.imageSourceURL) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: width - 20,
                               height: 250)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 15)
                        )
                        .clipped()
                        .shadow(radius: 4)
                } placeholder: {
                    Image(.img)
                        .resizable()
                        .scaledToFill()
                        .frame(width: width - 20,
                                height: 250)
                         .clipShape(
                             RoundedRectangle(cornerRadius: 15)
                         )
                    
                }
                VStack(spacing: 8) {
                    Text(article.content ?? "")
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Text(article.description ?? "")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 10)
                .lineLimit(2)
                
            }
            .padding(.horizontal, 10)
    }
}

#Preview {
    ArticleView(article: Article.defaultItem, width: 400)
}
