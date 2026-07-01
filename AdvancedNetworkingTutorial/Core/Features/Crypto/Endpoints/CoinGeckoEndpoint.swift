//
//  CoinGeckoEndpoint.swift
//  AdvancedNetworkingTutorial
//
//  Created by Sachin Randive on 01/07/26.
//

import Foundation

enum CoinGeckoEndpoint {
    case markets
    
    var path: String {
        switch self {
        case .markets:
            return "coins/markets"
        }
    }
}
