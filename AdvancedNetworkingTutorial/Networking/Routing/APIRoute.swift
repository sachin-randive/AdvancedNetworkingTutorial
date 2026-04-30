//
//  APIRoute.swift
//  AdvancedNetworkingTutorial
//
//  Created by Sachin Randive on 28/04/26.
//

import Foundation

struct URLConstants {
    static let fakeStoreURL: URL = URL(string: "https://api.escuelajs.co/api/v1/")!

}
enum APIRoute {
    case products(ProductEndpointPath)
    case users(UserEndpoint)
    
    var path: String {
        switch self {
        case .products(let productRoute):
            return productRoute.path
        case .users(let endpoint):
            return endpoint.path
        }
    }
}
