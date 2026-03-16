//
//  ArticleView.swift
//  NewsFeed
//
//  Created by  Prince Shrivastav on 14/03/26.
//

import SwiftUI

struct ArticleView: View {
    let width: CGFloat
    @State private var imageLoader = ImageManagerBuilder()
    @Environment(\.displayScale) var scale
    let state: ViewState<Article>
    var body: some View {
        let article = state.getItem
            VStack {
                if let image = imageLoader.image {
                    ImageView(image: image,
                              size: .init(width: width - 20,
                                          height: 250))
                } else {
                    Rectangle().fill(.secondary)
                        .frame(width: width - 20,
                               height: 250)
                        .shimmering()
                        .clipShape(.rect(cornerRadius: 15))
                    
                }
                VStack(alignment: .leading, spacing: 8) {
                    if case .loading = state {
                        Rectangle().fill(.secondary).opacity(0.5)
                        Rectangle().fill(.secondary).opacity(0.5)
                    } else {
                        Text(article?.title ?? "")
                            .font(.headline)
                            .foregroundStyle(.primary)
                        Text(article?.description ?? "")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 10)
                .lineLimit(2)
                
            }
            .padding(.horizontal, 10)
            .onAppear {
                if let imageURL = article?.imageSourceURL {
                    imageLoader.loadImage(url: imageURL,
                                          size: .init(width: width - 20, height: 250),
                                          scale: scale)
                }
            }
            .onDisappear {
                imageLoader.cancel()
            }
    }
}

#Preview {
    ArticleView(width: 400, state: .success(Article.defaultItem))
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
