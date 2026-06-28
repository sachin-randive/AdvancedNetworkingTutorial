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
    private let refreshCoordinator: TokenRefreshCoordinator
    
    init(session: URLSession = URLSession.shared, tokenStore: TokenStore = KeyChainTokenStore()) {
        let allowedHosts = Set([URLConstants.fakeStoreURL.host].compactMap { $0 })

        self.client = APIClient(
            baseURL: URLConstants.fakeStoreURL,
            session: session,
            decoder: JSONDecoder(),
            adapter: BearerTokenAdapter(tokenStore: tokenStore, allowedHosts: allowedHosts)
        )
        
        self.tokenStore = tokenStore
        self.refreshCoordinator = TokenRefreshCoordinator(client: client, tokenStore: tokenStore)
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
        tokenStore.clear()
        
        let request = APIRequest<AuthProfile>(
            method: .get,
            path: .auth(.profile)
        )
        
        do {
            let profile = try await client.execute(request)
            return profile
        } catch {
            print("DEBUG: Failed profile fetch with error:\(error.localizedDescription)")
            guard NetworkErrorMapper.map(error).statusCode == 401 else { throw error }
            
            do {
                try await refreshCoordinator.refreshIfNeeded()
                print("DEBUG: Refresh succeeded. Retrying request...")
            } catch {
                print("DEBUG: Refresh token failed. Logging user out.")
                logout()
                throw AuthError.sessionExpired
            }
            
            return try await client.execute(request)
        }
    }
}
