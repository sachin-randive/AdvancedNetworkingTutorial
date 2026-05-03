//
//  NetworkError.swift
//  AdvancedNetworkingTutorial
//
//  Created by Sachin Randive on 01/05/26.
//

import Foundation

enum NetworkError {
    case transport(URLError)
    case invalidResponse
    case httpStatus(code: Int)
    case decodingFailed(Error)
    case unknown(Error)
    
    var userMessage: String {
        switch self {
        case .transport(let urlError):
            switch urlError.code {
            case .notConnectedToInternet:
                return "No internet connection. check your network connection and try again"
                case .timedOut:
                return "Request timed out. Please try again"
            default:
                return "A network error occured. Please try again"
            }
        case .invalidResponse:
            return "Invalid response from server"
        case .httpStatus(code: let code):
            switch code {
            case 401:
                return "You are not authorized. Please sign in again."
            case 403:
                return "You don not have permission to perform this action."
            case 404:
                return "Resource not found"
            case 409:
                return "This action conflict with existing data."
            case 429:
                return "Too many request. Please wait a moment and try again."
            case 500...599:
                return "Internal server error. Please try again."
            default:
                return "Something went wrong. Please try again"
            }
        case .decodingFailed(let error):
            return "We received data in an unexpected format."
        case .unknown(_):
            return "Something went wrong. Please try again"
        }
    }
    var debugMessage: String {
        switch self {
        case .transport(let urlError):
            return "Transport error: \(urlError.code.rawValue) \(urlError.localizedDescription)"
        case .invalidResponse:
            return "Invalid non-HTTP response"
        case .httpStatus(code: let code):
            return "HTTP Status: \(code)"
        case .decodingFailed(let error):
            return "Decoding failed: \(error)"
            case .unknown(let error):
            return "Unknown error: \(error.localizedDescription)"
        }
    }
}
