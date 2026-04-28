//
//  APIRoute.swift
//  AdvancedNetworkingTutorial
//
//  Created by Sachin Randive on 28/04/26.
//

import Foundation

enum APIRoute {
    case products(ProductEndpointPath)
    
    var path: String {
        switch self {
        case .products(let productRoute):
            return productRoute.path
        }
    }
}
