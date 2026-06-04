//
//  NetworkLogEntry.swift
//  AdvancedNetworkingTutorial
//
//  Created by Sachin Randive on 02/06/26.
//

import Foundation

struct NetworkLogEntry: Identifiable, Hashable {
    let id: UUID
    let kind: Kind
    let timestamp: Date
    let method: HTTPMethod?
    let url: String?
    let statusCode: Int?
    let durationMs: Int?
    let fetchSource: String?
    let security: Security?
    let title: String
    let details: String
    let curlCommand: String?
    
    enum Kind: String,Hashable {
        case request
        case response
        case error
    }
    struct Security: Hashable {
        let tlsPinningEnabled: Bool
        let tlsPinningResult: String
        let tlsPinningFailureReason: String?
    }
    
    init(
        id: UUID = UUID(),
        kind: Kind,
        timestamp: Date = Date(),
        method: HTTPMethod? = nil,
        url: String? = nil,
        statusCode: Int? = nil,
        durationMs: Int? = nil,
        fetchSource: String? = nil,
        security: Security? = nil,
        title: String,
        details: String,
        curlCommand: String? = nil
    ) {
        self.id = id
        self.kind = kind
        self.timestamp = timestamp
        self.method = method
        self.url = url
        self.statusCode = statusCode
        self.durationMs = durationMs
        self.fetchSource = fetchSource
        self.security = security
        self.title = title
        self.details = details
        self.curlCommand = curlCommand
    }
}

extension NetworkLogEntry {
    static let mockRequest = NetworkLogEntry(
        kind: .request,
        method: .get,
        url: "https://api.example.com/v1/users?limit=20",
        statusCode: nil,
        durationMs: nil,
        fetchSource: "URLSession",
        security: Security(
            tlsPinningEnabled: true,
            tlsPinningResult: "success",
            tlsPinningFailureReason: nil
        ),
        title: "GET /v1/users",
        details: "Sending request to fetch users with limit=20",
        curlCommand: "curl -X GET 'https://api.example.com/v1/users?limit=20' -H 'Accept: application/json'"
    )

    static let mockResponse = NetworkLogEntry(
        kind: .response,
        method: .get,
        url: "https://api.example.com/v1/users?limit=20",
        statusCode: 200,
        durationMs: 142,
        fetchSource: "URLSession",
        security: Security(
            tlsPinningEnabled: true,
            tlsPinningResult: "success",
            tlsPinningFailureReason: nil
        ),
        title: "200 OK",
        details: "Received 20 users. Content-Type: application/json",
        curlCommand: nil
    )

    static let mockError = NetworkLogEntry(
        kind: .error,
        method: .post,
        url: "https://api.example.com/v1/login",
        statusCode: 401,
        durationMs: 95,
        fetchSource: "URLSession",
        security: Security(
            tlsPinningEnabled: true,
            tlsPinningResult: "failure",
            tlsPinningFailureReason: "Certificate mismatch"
        ),
        title: "Unauthorized",
        details: "Login failed with 401 Unauthorized. Check credentials or token.",
        curlCommand: "curl -X POST 'https://api.example.com/v1/login' -H 'Content-Type: application/json' -d '{\"email\":\"user@example.com\",\"password\":\"••••••\"}'"
    )

    static var mocks: [NetworkLogEntry] { [mockRequest, mockResponse, mockError] }
}
