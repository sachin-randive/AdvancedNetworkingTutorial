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
            insertorstartUsers(with: newUser)
        } catch {
            print("DEBUG: Failed to fetch users with error: \(error)")
        }
    }

    func updateUser(id: Int, payload: UpdateUserRequest) async {
        do {
            let newUser = try await service.update(id: id, with: payload)
            replaceUserIfLoaded(with: newUser)
        } catch {
            print("DEBUG: Failed to fetch users with error: \(error)")
        }
    }
    
    private func insertorstartUsers(with user: User) {
        switch loadingState {
        case .loaded(var  users):
            users.insert(user, at: 0)
            loadingState = .loaded(users)
        default:
            loadingState = .loaded([user])
        }
    }
    
    private func replaceUserIfLoaded(with user: User) {
        guard case .loaded(var users) = loadingState else { return }
        guard let index = users.firstIndex(where: { $0.id == user.id }) else { return }
        users[index] = user
        loadingState = .loaded(users)
    }
}
