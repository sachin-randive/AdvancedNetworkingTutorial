//
//  UserListViewModel.swift
//  AdvancedNetworkingTutorial
//
//  Created by Sachin Randive on 29/04/26.
//

import Foundation
import Observation


@Observable
final class UserListViewModel: @MainActor ListMutating {
    var loadingState: LoadingState<[User]> = .idle

    private let service: UserServiceProtocol
    
    init(service: UserServiceProtocol) {
        self.service = service
    }

    func loadUsers() async {
        loadingState = .loading
        do {
            let users = try await service.fetchUsers()
            loadingState = users.isEmpty ? .empty : .loaded(users)
        } catch {
            loadingState = .error(error.localizedDescription)
            print("DEBUG: Failed to fetch users with error: \(error)")
        }
    }

    func createUser(_ payload: CreateUserRequest) async {
        do {
            let newUser = try await service.create(payload)
            insertOrStart(with: newUser)
        } catch {
            print("DEBUG: Failed to fetch users with error: \(error)")
        }
    }

    func updateUser(id: Int, payload: UpdateUserRequest) async {
        do {
            let newUser = try await service.update(id: id, with: payload)
            replaceItemIfLoaded(with: newUser)
        } catch {
            print("DEBUG: Failed to fetch users with error: \(error)")
        }
    }
}
