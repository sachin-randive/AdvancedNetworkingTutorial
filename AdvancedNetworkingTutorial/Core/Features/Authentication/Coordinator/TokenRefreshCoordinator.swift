//
//  TokenRefreshCoordinator.swift
//  AdvancedNetworkingTutorial
//
//  Created by Sachin Randive on 28/06/26.
//

import Foundation
/*
 What the actor is protecting

 • The shared mutable state in​Flight​Refresh
    • Multiple concurrent requests can call refresh​If​Needed() at the same time (e.g., after a burst of 401s).
    • Without isolation, two threads could both see in​Flight​Refresh == nil and both create a new Task, defeating single-flight and reintroducing the race you’re trying to avoid.
    • Actor isolation makes reads/writes to in​Flight​Refresh mutually exclusive, so only one task is created; everyone else awaits the same task’s value.
 
 • Coordination around the refresh lifecycle
    • The sequence “check in​Flight​Refresh → create task → assign → await → clear” must be atomic with respect to other callers.
    • Actors serialize access to this sequence, so the defer { in​Flight​Refresh = nil } cannot interleave in unsafe ways with another caller’s check.
 
 • Consistent interaction with token​Store
    • Even if Token​Store is itself thread-safe, coordinating “load refresh token → call API → save tokens” is safer when the coordinator’s logic is serialized.
    • You avoid overlapping refreshes racing to write different tokens into the store.
 
 What can go wrong without an actor

 • Double refresh: Two callers both start a refresh because they both read in​Flight​Refresh == nil before either writes it.
 • Token clobbering: Overlapping refreshes return different tokens; the last write wins, potentially overwriting a fresher token.
 • Spurious logout/error paths: One refresh fails while another succeeds, and the failure path clears state mid-success.
 • Thundering herd: Backend receives multiple refresh calls instead of one, increasing load and risk of throttling.
*/

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
