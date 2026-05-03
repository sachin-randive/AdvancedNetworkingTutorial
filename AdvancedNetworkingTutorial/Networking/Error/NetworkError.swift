//
//  NetworkError.swift
//  AdvancedNetworkingTutorial
//
//  Created by Sachin Randive on 01/05/26.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case transport(URLError)
    case invalidResponse
    case httpStatus(code: Int)
    case decodingFailed(Error)
    case unknown(Error)
    
    var statusCode: Int? {
        guard case .httpStatus(let code) = self else { return nil }
        return code
    }
    
    var userMessage: String {
        switch self {
        case .transport(let urlError):
            switch urlError.code {
            case .notConnectedToInternet:
                return "No internet connection. Check your network and try again."
            case .timedOut:
                return "The request timed out. Please try again."
            default:
                return "A network error occurred. Please try again."
            }
        case .invalidResponse:
            return "The server returned an invalid response."
        case .httpStatus(let code):
            switch code {
            case 401:
                return "You are not authorized. Please sign in again."
            case 403:
                return "You do not have permission to perform this action."
            case 404:
                return "The requested resource could not be found."
            case 409:
                return "This action conflicts with existing data."
            case 429:
                return "Too many requests. Please wait a moment and try again."
            case 500...599:
                return "The server is having trouble right now. Please try again later."
            default:
                return "Something went wrong. Please try again."
            }
        case .decodingFailed:
            return "We received data in an unexpected format."
        case .unknown:
            return "Something went wrong. Please try again."
        }
    }
    
    var debugMessage: String {
        switch self {
        case .transport(let urlError):
            return "Transport error: \(urlError.code.rawValue) \(urlError.localizedDescription)"
        case .invalidResponse:
            return "Invalid non-HTTP response"
        case .httpStatus(let code):
            return "HTTP \(code)"
        case .decodingFailed(let error):
            return "Decoding failed: \(error)"
        case .unknown(let error):
            return "Unknown error: \(error.localizedDescription)"
        }
    }
    
    var errorDescription: String? { userMessage }
}

enum NetworkErrorMapper {
    static func map(_ error: Error) -> NetworkError {
        if let networkError = error as? NetworkError {
            return networkError
        }
        
        if let urlError = error as? URLError {
            return .transport(urlError)
        }
        
        return .unknown(error)
    }
    
    static func httpStatus(code: Int) -> NetworkError {
        .httpStatus(code: code)
    }
    
    static func decodeFailure(_ error: Error) -> NetworkError {
        .decodingFailed(error)
    }
}
