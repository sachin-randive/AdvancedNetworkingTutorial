//
//  AuthenticationService.swift
//  AdvancedNetworkingTutorial
//
//  Created by Sachin Randive on 09/06/26.
//

import Foundation

protocol AuthenticationServiceProtocol {
    func login(payload: LoginRequest) async throws
    func logout()
    func currentAccessToken() -> String?
    func fetchProfile() async throws -> AuthProfile
}

struct AuthenticationService: AuthenticationServiceProtocol {
    private let client: APIClient
    private let tokenStore: TokenStore
    
    init(session: URLSession = URLSession.shared, tokenStore: TokenStore = InMemoryTokenStore()) {
        self.client = APIClient(
            baseURL: URLConstants.fakeStoreURL,
            session: session,
            decoder: JSONDecoder()
        )
        self.tokenStore = tokenStore
    }
    
    func login(payload: LoginRequest) async throws {
        let request = try APIRequest<AuthTokenResponse>(
            method: .post,
            path: .auth(.login),
            body: payload
        )
        
        let tokens = try await client.execute(request)
        
        tokenStore.save(accessToken: tokens.accessToken, refreshToken: tokens.refreshToken)
    }
    
    func logout() {
        tokenStore.clear()
    }
    
    func currentAccessToken() -> String? {
        tokenStore.loadAccessToken()
    }
    
    func fetchProfile() async throws -> AuthProfile {
        return AuthProfile(id: 1, email: "test@gmail.com", name: "Test", role: "test", avatar: "")
    }
}
