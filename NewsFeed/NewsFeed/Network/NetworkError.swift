//
//  NetworkError.swift
//  NewsFeed
//
//  Created by  Prince Shrivastav on 13/03/26.
//

import Foundation

enum NetworkError: Error {
    case invalidResponse
    case invalidURL
    case decodingFailed
    case unauthorized
    case refreshTokenMissing
    case server(Int)
    case underlying(Error)
    case message(String)
}
