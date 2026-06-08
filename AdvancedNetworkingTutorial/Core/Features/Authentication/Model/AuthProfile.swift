//
//  AuthProfile.swift
//  AdvancedNetworkingTutorial
//
//  Created by Sachin Randive on 08/06/26.
//

import Foundation

struct AuthProfile: Decodable, Identifiable {
    let id: Int
    let email: String
    let name: String
    let role: String
    let avatar: String
}
