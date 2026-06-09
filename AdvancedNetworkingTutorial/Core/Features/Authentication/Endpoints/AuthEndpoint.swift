//
//  AuthEndpoint.swift
//  AdvancedNetworkingTutorial
//
//  Created by Sachin Randive on 09/06/26.
//

import Foundation

enum AuthEndpoint {
    case login
    case profile
    case refreshToken
    
    var path: String {
        switch self {
        case .login:
            return "auth/login"
        case .profile:
            return "auth/profile"
        case .refreshToken:
            return "auth/refresh-token"
        }
    }
}
