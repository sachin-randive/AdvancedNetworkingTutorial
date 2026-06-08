//
//  UserService.swift
//  AdvancedNetworkingTutorial
//
//  Created by Sachin Randive on 29/04/26.
//

import Foundation

protocol UserServiceProtocol {
    func fetchUsers() async throws -> [User]
    func create(_ payload: CreateUserRequest) async throws -> User
    func update(id: Int, with payload: UpdateUserRequest) async throws -> User
}

struct UserService: UserServiceProtocol {
    private let client: APIClient
    
    init() {
        client = APIClient(baseURL: URLConstants.fakeStoreURL)
    }
    
    func fetchUsers() async throws -> [User] {
        let requestModel = APIRequest<[User]>(method: .get, path: .users(.list))
        return try await client.execute(requestModel)
    }
    
    func create(_ payload: CreateUserRequest) async throws -> User {
        let requestModel = try APIRequest<User>(method: .post, path: .users(.list), body: payload)
        return try await client.execute(requestModel)
    }
    
    func update(id: Int, with payload: UpdateUserRequest) async throws -> User {
        let requestModel = try APIRequest<User>(method: .put, path: .users(.byID(id)), body: payload)
        return try await client.execute(requestModel)
    }
}
