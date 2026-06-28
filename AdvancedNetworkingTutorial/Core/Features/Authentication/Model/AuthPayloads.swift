//
//  AuthPayloads.swift
//  AdvancedNetworkingTutorial
//
//  Created by Sachin Randive on 09/06/26.
//

import Foundation

struct LoginRequest: Encodable {
    let email: String
    let password: String
}

nonisolated struct AuthTokenResponse: Decodable {
    let accessToken: String
    let refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}

nonisolated struct RefreshTokenRequest: Encodable {
    let refreshToken: String
}
