//
//  LoadingState.swift
//  AdvancedNetworkingTutorial
//
//  Created by Sachin Randive on 05/05/26.
//

import Foundation

enum LoadingState<value: Decodable> {
    case idle
    case loading
    case empty
    case error(String)
    case loaded(value)
}
