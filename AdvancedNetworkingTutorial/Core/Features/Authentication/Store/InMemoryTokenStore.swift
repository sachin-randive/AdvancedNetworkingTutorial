//
//  InMemoryTokenStore.swift
//  AdvancedNetworkingTutorial
//
//  Created by Sachin Randive on 12/06/26.
//

import Foundation

final class InMemoryTokenStore: TokenStore {
    private var accessToken: String?
    private var refreshToken: String?
    
    func loadAccessToken() -> String? {
        accessToken
    }
    
    func loadRefreshToken() -> String? {
        refreshToken
    }
    
    func save(accessToken: String, refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
    
    func clear() {
        accessToken = nil
        refreshToken = nil
    }
}
