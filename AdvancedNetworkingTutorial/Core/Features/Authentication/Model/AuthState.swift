//
//  AuthState.swift
//  AdvancedNetworkingTutorial
//
//  Created by Sachin Randive on 11/06/26.
//

import Foundation

enum AuthState: Equatable {
    case unknown
    case signOut
    case signingIn
    case signedIn
    case error(String)
}
