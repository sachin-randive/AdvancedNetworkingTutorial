//
//  RequestAdapter.swift
//  AdvancedNetworkingTutorial
//
//  Created by Sachin Randive on 26/06/26.
//

import Foundation

protocol RequestAdapter {
    func adapt(_ request: URLRequest) -> URLRequest
}
