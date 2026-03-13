//
//  NetworkManager.swift
//  NewsFeed
//
//  Created by  Prince Shrivastav on 13/03/26.
//

import Foundation

protocol NetworkBuilder {
    var requestBuilder: URLRequestBuilder { get }
    var urlSessionBuilder: URLSessionBuilder { get }
    var requestParser: URLDataRequestParser { get }
    
    func fetchRequest<D>(for endpoint: Endpoint) async throws -> D where D: Decodable
}

final class NetworkManager: NetworkBuilder {
    
    let requestBuilder: URLRequestBuilder
    let urlSessionBuilder: URLSessionBuilder
    let requestParser: URLDataRequestParser
    
    init(requestBuilder: URLRequestBuilder = URLRequestBuilderManager() ,
         urlSessionBuilder: URLSessionBuilder = URLSessionBuilderManager() ,
         requestParser: URLDataRequestParser = URLDataRequestParserBuilder()) {
        self.requestBuilder = requestBuilder
        self.urlSessionBuilder = urlSessionBuilder
        self.requestParser = requestParser
    }
    
    func fetchRequest<D>(for endpoint: Endpoint) async throws -> D where D: Decodable {
        let request = try await requestBuilder.getURLRequest(for: endpoint)
        
        do {
            let (data, response) = try await urlSessionBuilder.perform(url: request)
            return try handleResponse(data: data, response: response)
        } catch {
            throw mapError(error: error)
        }
    }
    
}

// MARK: - Private Method
private extension NetworkManager {
    
    func handleResponse<D>(data: Data,
                           response: URLResponse) throws -> D where D: Decodable {
        
        guard let httpResponse = response as? HTTPURLResponse else { throw NetworkError.invalidResponse }
        
        switch httpResponse.statusCode {
        case 200...299:
            return try requestParser.parseData(for: data)
        default:
            throw NetworkError.server(httpResponse.statusCode)
            
        }
    }
    
    func mapError(error: Error) -> NetworkError {
        if let error = error as? NetworkError { return error }
        return NetworkError.underlying(error)
    }
}
