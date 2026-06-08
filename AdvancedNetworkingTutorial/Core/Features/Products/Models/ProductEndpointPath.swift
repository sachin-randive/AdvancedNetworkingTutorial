//
//  ProductEndpointPath.swift
//  AdvancedNetworkingTutorial
//
//  Created by Sachin Randive on 28/04/26.
//

import Foundation

enum ProductEndpointPath {
    case list
    case byId(Int)
    
    var path: String {
        switch self {
        case .list:
            return "/products"
        case .byId(let id):
            return "products/\(id)"
        }
    }
}
