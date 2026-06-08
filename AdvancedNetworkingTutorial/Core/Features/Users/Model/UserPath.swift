//
//  UserPath.swift
//  AdvancedNetworkingTutorial
//
//  Created by Sachin Randive on 30/04/26.
//
enum UserEndpoint {
    case list
    case byID(Int)
    case emailAvailability

    var path: String {
        switch self {
        case .list:
            return "users"
        case .byID(let id):
            return "users/\(id)"
        case .emailAvailability:
            return "users/is-available"
        }
    }
}
