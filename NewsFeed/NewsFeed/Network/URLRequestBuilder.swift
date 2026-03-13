//
//  URLRequestBuilder.swift
//  NewsFeed
//
//  Created by  Prince Shrivastav on 13/03/26.
//

import Foundation

protocol URLRequestBuilder {
    func getURLRequest(for endPoint: Endpoint) async throws -> URLRequest
}

final class URLRequestBuilderManager: URLRequestBuilder {
    func getURLRequest(for endPoint: any Endpoint) async throws -> URLRequest {
        guard var urlComponent = URLComponents(url: endPoint.baseURL,
                                               resolvingAgainstBaseURL: false) else {
            throw NetworkError.invalidURL
        }
        urlComponent.path = endPoint.path
        urlComponent.queryItems = endPoint.queryItems
        
        guard let url = urlComponent.url else {
            throw NetworkError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = endPoint.method.rawValue
        request.allHTTPHeaderFields = endPoint.headers
        request.httpBody = endPoint.body
        return request
    }
}
