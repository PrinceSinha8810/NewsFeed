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
    
    var publishedDate: Date? {
        let formatter = ISO8601DateFormatter()
        let date = formatter.date(from: publishedAt ?? "")
        return date
    }
    
    static let defaultItem = Article(title: "ECB reminds Hundred franchises of responsibilities",
                                     description: "The Verge is heading to Barcelona, Spain, for Mobile World Congress, the biggest phone show of the year. CES may dominate the headlines when it comes to TVs, computer components, and AI inanity, but for all things mobile MWC has it beat. Since it’s a global s…",
                                     imageURL: "https://ichef.bbci.co.uk/ace/branded_sport/1200/cpsprodpb/b692/live/2d982970-0fda-11f1-b048-c9424b2cf5fd.jpg",
                                     link: "https://www.theverge.com/tech/882980/mwc-2026-news-phones-gadgets-announcements",
                                     author: "Dominic Preston",
                                     publishedAt: "2026-02-27T08:50:07Z",
                                     content: "The England and Wales Cricket Board (ECB) has written to the eight Hundred franchises reminding them of their responsibilities around discrimination.\r\nEarlier this week, BBC Sport reported Pakistan c… [+1403 chars]",
                                     source: .init(id: "the-verge",
                                                   name: "The Verge"))
}

struct Source: Decodable {
    let id: String?
    let name: String
}
