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
    let imageLoader: ImageManager = ImageManagerBuilder()
    
    var body: some View {
            VStack {
                if let image = imageLoader.image {
                    ImageView(image: image,
                              size: .init(width: width - 20,
                                          height: 250))
                } else {
                    ImageView(image: UIImage(resource: .img),
                              size: .init(width: width - 20,
                                          height: 250))
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
            .onAppear {
                if let imageURL = article.imageSourceURL {
                    imageLoader.loadImage(url: imageURL)
                }
            }
            .onDisappear {
                imageLoader.cancel()
            }
    }
}

#Preview {
    ArticleView(article: Article.defaultItem, width: 400)
}

struct ImageView: View {
    let image: UIImage
    var radius: CGFloat =  15
    let size: CGSize
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFill()
            .frame(width:size.width,
                   height: size.height)
             .clipShape(
                 RoundedRectangle(cornerRadius: radius)
             )
    }
}
