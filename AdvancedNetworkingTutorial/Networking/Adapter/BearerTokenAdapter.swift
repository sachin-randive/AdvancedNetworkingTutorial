//
//  BearerTokenAdapter.swift
//  AdvancedNetworkingTutorial
//
//  Created by Sachin Randive on 26/06/26.
//

import Foundation

struct BearerTokenAdapter: RequestAdapter {
    let tokenStore: TokenStore
    let allowedHosts: Set<String>
    
    func adapt(_ request: URLRequest) -> URLRequest {
        guard
            let host = request.url?.host,
            allowedHosts.contains(host),
            let token = tokenStore.loadAccessToken(),
            !token.isEmpty else {
            return request
        }
        
        var adapted = request
        adapted.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return adapted
    }
}
