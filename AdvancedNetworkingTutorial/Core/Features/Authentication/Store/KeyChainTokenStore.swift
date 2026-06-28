//
//  KeyChainTokenStore.swift
//  AdvancedNetworkingTutorial
//
//  Created by Sachin Randive on 18/06/26.
//

import Foundation
import Security

final class KeyChainTokenStore: TokenStore {
    private let service = "abc.AdvancedNetworkingTutorial.auth"
    private let accessTokenAccountKey = "access_token"
    private let refreshTokenAccountKey = "refresh_token"
    
    func loadAccessToken() -> String? {
        read(account: accessTokenAccountKey)
    }
    
    func loadRefreshToken() -> String? {
        read(account: refreshTokenAccountKey)
    }
    
    func save(accessToken: String, refreshToken: String) {
        upsert(value: accessToken, account: accessTokenAccountKey)
        upsert(value: refreshToken, account: refreshTokenAccountKey)
    }
    
    func clear() {
        delete(account: accessTokenAccountKey)
       // delete(account: refreshTokenAccountKey)
    }
}

private extension KeyChainTokenStore {
    func upsert(value: String, account: String) {
        guard let data = value.data(using: .utf8) else { return }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        
        let attributes: [String: Any] = [
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        ]
        
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        
        if status == errSecItemNotFound {
            var addQuery = query
            attributes.forEach { addQuery[$0.key] = $0.value }
            SecItemAdd(addQuery as CFDictionary, nil)
        }
        
        print("DEBUG: Saved token to keychain")
    }
    
    func read(account: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess,
              let data = result as? Data,
              let value = String(data: data, encoding: .utf8) else {
            print("DEBUG: Token not found in keychain..")
            return nil
        }
        
        print("DEBUG: Got token from keychain")
        return value
    }
    
    func delete(account: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        
        SecItemDelete(query as CFDictionary)
    }
}
