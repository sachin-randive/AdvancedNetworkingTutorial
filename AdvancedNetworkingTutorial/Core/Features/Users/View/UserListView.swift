//
//  UserListView.swift
//  AdvancedNetworkingTutorial
//
//  Created by Sachin Randive on 29/04/26.
//

import SwiftUI
import Kingfisher

struct UserListView: View {
    @Environment(AuthenticationManager.self) private var authManager
    
    @State private var viewModel = UserListViewModel(service: UserService())
    @State private var hasLoaded = false
    @State private var formIntent: UserFormIntent?
    @State private var isShowingProfile = false
    
    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.loadingState {
                case .idle, .loading:
                    ProgressView()
                case .empty:
                    Text("No Users to display")
                case .error(let errorMessage):
                    Text(errorMessage)
                case .loaded(let users):
                    List(users) { user in
                        UserRowView(user: user)
                            .padding(.vertical, 6)
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button("Edit") {
                                    formIntent = .update(user)
                                }
                                .tint(.blue)
                            }
                    }
                }
            }
            .sheet(isPresented: $isShowingProfile) {
                ProfileView()
                    .environment(authManager)
            }
            .listStyle(.plain)
            .navigationTitle("Users")
            .networkLogsSheet()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        isShowingProfile = true
                    } label: {
                        Image(systemName: "person")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        formIntent = .create
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        
        .refreshable { await viewModel.loadUsers() }
        .sheet(item: $formIntent) { intent in
            UserFormView(intent: intent)
                .environment(viewModel)
        }
        .task {
            await viewModel.loadUsers()
            hasLoaded = true
        }
    }
}

#Preview {
    UserListView()
}
