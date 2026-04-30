//
//  UserListViewModel.swift
//  AdvancedNetworkingTutorial
//
//  Created by Sachin Randive on 29/04/26.
//

import Foundation
import Observation

@MainActor
@Observable
final class UserListViewModel {
    var users: [User] = []

    private let service: UserServiceProtocol
    
    init(service: UserServiceProtocol) {
        self.service = service
    }

    func loadUsers() async {
        do {
            self.users = try await service.fetchUsers()
        } catch {
            print("DEBUG: Failed to fetch users with error: \(error)")
        }
    }

    func createUser(_ payload: CreateUserRequest) async {
        do {
            let newUser = try await service.create(payload)
            users.insert(newUser, at: 0)
        } catch {
            print("DEBUG: Failed to fetch users with error: \(error)")
        }
    }

    func updateUser(id: Int, payload: UpdateUserRequest) async {
        guard let index = users.firstIndex(where: { $0.id == id }) else { return }
        
        do {
            let newUser = try await service.update(id: id, with: payload)
            users[index] = newUser
        } catch {
            print("DEBUG: Failed to fetch users with error: \(error)")
        }
    }
}
