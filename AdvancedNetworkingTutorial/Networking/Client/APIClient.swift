//
//  APIClient.swift
//  AdvancedNetworkingTutorial
//
//  Created by Sachin Randive on 29/04/26.
//

import Foundation

struct APIClient {
    let baseURL: URL
    var sesion: URLSession = .shared
    var decoder: JSONDecoder = JSONDecoder()
    
    func execute<Response>(_ requestModel: APIRequest<Response>) async throws -> Response {
        let request = try requestModel.makeURLRequest(baseURL: baseURL)
        
        let (data, response) = try await sesion.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        guard 200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        
        return try decoder.decode(Response.self, from: data)
    }
}
