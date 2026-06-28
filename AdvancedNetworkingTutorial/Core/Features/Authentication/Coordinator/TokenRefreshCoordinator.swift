//
//  TokenRefreshCoordinator.swift
//  AdvancedNetworkingTutorial
//
//  Created by Sachin Randive on 28/06/26.
//

import Foundation

actor TokenRefreshCoordinator {
    private var inFlightRefresh: Task<Void, Error>?
    
    private let client: APIClient
    private let tokenStore: TokenStore
    
    init(client: APIClient, tokenStore: TokenStore) {
        self.client = client
        self.tokenStore = tokenStore
    }
    
    func refreshIfNeeded() async throws {
        if let inFlightRefresh {
            return try await inFlightRefresh.value
        }
        
        let task = Task { try await self.performRefresh() }
        inFlightRefresh = task
        defer { inFlightRefresh = nil }
        
        try await task.value
    }
    
    private func performRefresh() async throws {
        guard let refreshToken = await tokenStore.loadRefreshToken(), !refreshToken.isEmpty else {
            throw AuthError.missingRefreshToken
        }
        
        let request = try await APIRequest<AuthTokenResponse>(
            method: .post,
            path: .auth(.refreshToken),
            body: RefreshTokenRequest(refreshToken: refreshToken)
        )
        
        let tokens = try await client.execute(request)
        await tokenStore.save(
            accessToken: tokens.accessToken,
            refreshToken: tokens.refreshToken
        )
    }
}
