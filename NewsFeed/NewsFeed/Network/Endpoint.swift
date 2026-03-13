//
//  Endpoint.swift
//  NewsFeed
//
//  Created by  Prince Shrivastav on 13/03/26.
//

import Foundation

enum AuthorizationRequirement {
    case none
    case accessToken
}

protocol Endpoint {
    var baseURL: URL { get }
    var path: String { get }
    var method: HttpMethod { get }
    var headers: [String: String]? { get }
    var body: Data? { get }
    var queryItems: [URLQueryItem]? { get }
    var authorization: AuthorizationRequirement { get }
}
extension Endpoint {
    var headers: [String: String]? { nil }
    var queryItems: [URLQueryItem]? { nil }
    var body: Data? { nil }
    var authorization: AuthorizationRequirement { .accessToken }
}
