//
//  APIRequest.swift
//  AdvancedNetworkingTutorial
//
//  Created by Sachin Randive on 27/04/26.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

struct EmptyResponse: Decodable { }

struct APIRequest<Response: Decodable> {
    let method: HTTPMethod
    let path: APIRoute
    var queryItems: [URLQueryItem]
    var headers: [String: String]
    var body: Data?
    
    init(
        method: HTTPMethod,
        path: APIRoute,
        queryItems: [URLQueryItem] = [],
        headers: [String : String] = [:],
        body: Data? = nil
    ) {
        self.method = method
        self.path = path
        self.headers = headers
        self.body = body
        self.queryItems = queryItems
    }
    
    init<Body: Encodable>(
        method: HTTPMethod,
        path: APIRoute,
        queryItems: [URLQueryItem] = [],
        headers: [String : String] = [:],
        encoder: JSONEncoder = JSONEncoder(),
        body: Body
    ) throws {
        self.method = method
        self.path = path
        self.headers = headers
        self.body = try encoder.encode(body)
        self.queryItems = queryItems
        
        if self.headers["Content-Type"] == nil {
            self.headers["Content-Type"] = "application/json"
        }
    }
    
    func makeURLRequest(baseURL: URL, defaultHeaders: [String: String] = [:]) throws -> URLRequest {
        guard var components = URLComponents(url: baseURL.appendingPathComponent(path.path), resolvingAgainstBaseURL: true) else {
            throw URLError(.badURL)
        }
        
        if !queryItems.isEmpty {
            components.queryItems = queryItems
        }
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        var mergeHeaders = defaultHeaders
        mergeHeaders.merge(headers) { (_, new) in new }
        request.allHTTPHeaderFields = mergeHeaders
        
        request.httpBody = body
        
        return request
    }
}

