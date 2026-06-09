//
//  AuthenticationManager.swift
//  AdvancedNetworkingTutorial
//
//  Created by Sachin Randive on 09/06/26.
//

import Foundation

@Observable @MainActor
final class AuthenticationManager {
    private let service: AuthenticationServiceProtocol
    
    init(service: AuthenticationServiceProtocol) {
        self.service = service
    }
    
    func login(payload: LoginRequest) async {
        do {
            try await service.login(payload: payload)
        } catch {
            print("DEBUG: Login failed with error: \(error)")
        }
    }
}
