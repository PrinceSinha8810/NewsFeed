//
//  NewsDetailView.swift
//  NewsFeed
//
//  Created by  Prince Shrivastav on 14/03/26.
//

import SwiftUI

struct NewsDetailView: View {
    let article: Article
    let imageLoader: ImageManager = ImageManagerBuilder()
    @Environment(\.displayScale) var scale
    var body: some View {
        GeometryReader { geo in
            let size = geo.size
            ScrollView {
                if let image = imageLoader.image {
                    ImageView(image: image,
                              radius: 0,
                              size: .init(width: size.width,
                                          height: size.height * 0.6))
                }
                
                /// Content
                VStack(alignment: .leading, spacing: 10) {
                    Text(article.title)
                        .font(.system(size: 25, weight: .bold))
                        .foregroundStyle(.primary)
                    HStack {
                        Text("Author: \(article.author ?? "")")
                        Spacer()
                        Text(article.publishedDate!, style: .date)
                    }
                    .foregroundStyle(.secondary)
                    Text(article.content ?? "")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundStyle(.primary)
                    Text(article.description ?? "")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundStyle(.primary)
                }
                .padding(.horizontal, 10)
            }
            .edgesIgnoringSafeArea(.top)
            .onAppear() {
                if let imageURL = article.imageSourceURL {
                    imageLoader.loadImage(url: imageURL,
                                          size: .init(width: size.width,
                                                      height: size.height * 0.6),
                                          scale: scale)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    UIApplication.shared.open(URL(string: article.link ?? "")!) { _ in
                        
                    }
                } label: {
                    Image(systemName: "square.and.arrow.up.circle")
                }

            }
        }
    }
}

#Preview {
    NewsDetailView(article: Article.defaultItem)
}
