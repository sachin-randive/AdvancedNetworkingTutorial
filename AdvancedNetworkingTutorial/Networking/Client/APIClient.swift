//
//  APIClient.swift
//  AdvancedNetworkingTutorial
//
//  Created by Sachin Randive on 29/04/26.
//

import Foundation

struct APIClient {
    let baseURL: URL
    var session: URLSession = .shared
    var decoder: JSONDecoder = JSONDecoder()
    var adapter: RequestAdapter?
    
    let logger = NetworkLogStore.shared
    
    func execute<Response>(_ requestModel: APIRequest<Response>) async throws -> Response {
        let start = Date()
        
        do {
            let request = try makeAdaptedRequest(for: requestModel)
            logRequest(request)
            
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            logResponse(
                request: request,
                response: httpResponse,
                data: data,
                duration: Date().timeIntervalSince(start),
                fetchSource: "Network"
            )
            
            guard (200..<300).contains(httpResponse.statusCode) else {
                throw NetworkError.httpStatus(code: httpResponse.statusCode)
            }
            
            return try decoder.decode(Response.self, from: data)
        } catch {
            let mapped = NetworkErrorMapper.map(error)
            logError(mapped, duration: Date().timeIntervalSince(start))
            throw mapped
        }
    }
}

// Adaptation
private extension APIClient {
    func makeAdaptedRequest<Response>(for request: APIRequest<Response>) throws -> URLRequest {
        let rawRequest = try request.makeURLRequest(baseURL: baseURL)
        
        guard let adapter else { return rawRequest }
        return adapter.adapt(rawRequest)
    }
}

// Logging
private extension APIClient {
    func logRequest(_ request: URLRequest) {
        guard let method = request.httpMethod else { return }
        let url = request.url?.absoluteString ?? "nil"
        let headers = request.allHTTPHeaderFields ?? [:]
        var bodyPreview: String?
        
        if let body = request.httpBody {
            bodyPreview = String(data: body, encoding: .utf8)
        }
        
        let details = [
            "URL: \(url)",
            "Headers: \(headers)",
            "Body: \(bodyPreview ?? "<empty>")"
        ]
            .compactMap { $0 }
            .joined(separator: "\n")
        
        logger.log(
            NetworkLogEntry(
                kind: .request,
                method: HTTPMethod(rawValue: method),
                url: url,
                title: "\(request.httpMethod ?? "REQUEST") \(request.url?.lastPathComponent ?? "")",
                details: details
            )
        )
    }
    
    func logResponse(
        request: URLRequest,
        response: HTTPURLResponse,
        data: Data,
        duration: TimeInterval,
        fetchSource: String
    ) {
        guard let method = request.httpMethod else { return }
        let bodyPreview = String(data: data, encoding: .utf8)?.prefix(800) ?? ""
        
        let details = [
            "URL: \(request.url?.absoluteString ?? "nil")",
            "Status: \(response.statusCode)",
            "Duration: \(Int(duration * 1000))ms",
            bodyPreview.isEmpty ? nil : "Body: \(bodyPreview)"
        ]
            .compactMap { $0 }
            .joined(separator: "\n")
        
        logger.log(
            .init(
                kind: .response,
                method: HTTPMethod(rawValue: method),
                url: request.url?.absoluteString,
                statusCode: response.statusCode,
                durationMs: Int(duration * 1000),
                fetchSource: fetchSource,
                title: "HTTP \(response.statusCode)",
                details: details
            )
        )
    }
    
    func logError(_ error: NetworkError, duration: TimeInterval) {
        logger.log(
            .init(
                kind: .error,
                statusCode: error.statusCode,
                durationMs: Int(duration * 1000),
                title: error.localizedDescription,
                details: error.debugMessage
            )
        )
    }
}
