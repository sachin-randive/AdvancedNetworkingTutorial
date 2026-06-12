//
//  TokenStore.swift
//  AdvancedNetworkingTutorial
//
//  Created by Sachin Randive on 12/06/26.
//

import Foundation

protocol TokenStore {
    func loadAccessToken() -> String?
    func loadRefreshToken() -> String?
    func save(accessToken: String, refreshToken: String)
    func clear()
}
