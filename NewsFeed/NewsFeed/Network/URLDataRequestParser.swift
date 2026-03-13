//
//  URLDataRequestParser.swift
//  NewsFeed
//
//  Created by  Prince Shrivastav on 13/03/26.
//

import Foundation

protocol URLDataRequestParser {
    func parseData<T>(for data: Data) throws -> T where T: Decodable
}

final class URLDataRequestParserBuilder: URLDataRequestParser {
    
    let decoder: JSONDecoder
    init(decoder: JSONDecoder = JSONDecoder()) {
        self.decoder = decoder
    }
    
    func parseData<T>(for data: Data) throws -> T where T: Decodable {
        return try decoder.decode(T.self,
                              from: data)
    }
}
