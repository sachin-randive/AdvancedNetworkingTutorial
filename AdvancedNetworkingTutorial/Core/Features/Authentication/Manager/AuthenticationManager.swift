//
//  AuthenticationManager.swift
//  AdvancedNetworkingTutorial
//
//  Created by Sachin Randive on 09/06/26.
//

import Foundation

@Observable @MainActor
final class AuthenticationManager {
    var authState: AuthState = .unknown
    var authProfile: AuthProfile?
    private let service: AuthenticationServiceProtocol
    
    init(service: AuthenticationServiceProtocol) {
        self.service = service
        
        if service.currentAccessToken() != nil {
            authState = .signedIn
        } else {
            authState = .signOut
        }
    }
    
    func login(payload: LoginRequest) async {
        authState = .signingIn
        do {
            try await service.login(payload: payload)
            authState = .signedIn
        } catch {
            print("DEBUG: Login failed with error: \(error)")
            authState = .error(error.localizedDescription)
        }
    }
    
    func fertchProfile() async {
        do {
            self.authProfile = try await service.fetchProfile()
        } catch {
            print("DEBUG: Profile fetch failed with error: \(error)")
        }
    }
    
    func logout() {
        service.logout()
        authState = .signOut
    }
}
