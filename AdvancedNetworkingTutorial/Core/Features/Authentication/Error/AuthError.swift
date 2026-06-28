//
//  AuthError.swift
//  AdvancedNetworkingTutorial
//
//  Created by Sachin Randive on 28/06/26.
//

import Foundation

enum AuthError: LocalizedError {
    case missingAccessToken
    case missingRefreshToken
    case sessionExpired
    
    var errorDescription: String? {
        switch self {
        case .missingAccessToken:
            return "No access token is available. Please log in first."
        case .missingRefreshToken:
            return "No refresh token is available. Please sign in again."
        case .sessionExpired:
            return "Your session expired. Please sign in again."
        }
    }
}
