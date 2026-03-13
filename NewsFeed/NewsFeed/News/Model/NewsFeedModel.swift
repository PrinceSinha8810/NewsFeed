//
//  NewsFeedModel.swift
//  NewsFeed
//
//  Created by  Prince Shrivastav on 13/03/26.
//

import Foundation

struct NewsResponse: Decodable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

struct Article: Decodable, Identifiable {
    let id = UUID()
    let title: String
    let description: String?
    let imageURL: String?
    let link: String?
    let author: String?
    let publishedAt: String?
    let content: String?
    let source: Source?
    
    private enum CodingKeys: String, CodingKey {
        case title
        case description
        case imageURL = "urlToImage"
        case link = "url"
        case author
        case publishedAt
        case content
        case source
    }
   
}
extension Article {
    var imageSourceURL: URL? {
        URL(string: imageURL ?? "https://platform.theverge.com/wp-content/uploads/sites/2/2026/02/mwc.jpg?quality=90&strip=all&crop=0%2C10.741906587151%2C100%2C78.516186825698&w=1200")
    }
    static let defaultItem = Article(title: "Dominic Preston",
                                     description: "The Verge is heading to Barcelona, Spain, for Mobile World Congress, the biggest phone show of the year. CES may dominate the headlines when it comes to TVs, computer components, and AI inanity, but for all things mobile MWC has it beat. Since it’s a global s…",
                                     imageURL: "https://platform.theverge.com/wp-content/uploads/sites/2/2026/02/mwc.jpg?quality=90&strip=all&crop=0%2C10.741906587151%2C100%2C78.516186825698&w=1200",
                                     link: "https://www.theverge.com/tech/882980/mwc-2026-news-phones-gadgets-announcements",
                                     author: "Dominic Preston",
                                     publishedAt: "2026-02-27T08:50:07Z",
                                     content: "The Verge is heading to Barcelona, Spain, for Mobile World Congress, the biggest phone show of the year.\r\nCES may dominate the headlines when it comes to TVs, computer components, and AI inanity, but… [+3801 chars]",
                                     source: .init(id: "the-verge",
                                                   name: "The Verge"))
}

struct Source: Decodable {
    let id: String?
    let name: String
}
