//
//  UserFormView.swift
//  AdvancedNetworkingTutorial
//
//  Created by Sachin Randive on 30/04/26.
//

import SwiftUI

struct UserFormView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(UserListViewModel.self) private var viewModel

    let intent: UserFormIntent

    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var avatarURL = "https://picsum.photos/200/200"
    @State private var validationMessage: String?
    @State private var hasPopulatedFromIntent = false
    @State private var isShowingMutationErrorAlert = false
    @State private var mutationErrorMessage = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Basics") {
                    TextField("Name", text: $name)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()

                    if case .create = intent {
                        SecureField("Password", text: $password)
                    }
                }

                Section("Avatar") {
                    TextField("Avatar URL", text: $avatarURL)
                        .keyboardType(.URL)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }

                if let validationMessage {
                    Section {
                        Text(validationMessage)
                            .font(.footnote)
                            .foregroundStyle(.red)
                    }
                }
            }
            .alert("Couldn’t Save Product", isPresented: $isShowingMutationErrorAlert) {
                Button("OK") {
                    viewModel.resetMutationState()
                }
            } message: {
                Text(mutationErrorMessage)
            }
            .interactiveDismissDisabled(isSavingCurrentIntent)
            .onAppear {
                populateFormIfNeeded()
            }
            .navigationTitle(intent.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                        .disabled(isSavingCurrentIntent)
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button { Task { await submit() } } label: {
                        ZStack {
                            if isSavingCurrentIntent {
                                ProgressView()
                            } else {
                                Text(intent.submitTitle)
                            }
                        }
                    }
                    .disabled(isSavingCurrentIntent)
                }
            }
        }
    }

    private func submit() async {
        validationMessage = nil

        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedAvatarURL = avatarURL.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedName.isEmpty else {
            validationMessage = "Name is required."
            return
        }

        guard !trimmedEmail.isEmpty else {
            validationMessage = "Email is required."
            return
        }

        guard trimmedEmail.contains("@") else {
            validationMessage = "Enter a valid email."
            return
        }

        if case .create = intent {
            guard !trimmedPassword.isEmpty else {
                validationMessage = "Password is required."
                return
            }
        }

        guard !trimmedAvatarURL.isEmpty else {
            validationMessage = "Avatar URL is required."
            return
        }

        switch intent {
        case .create:
            let payload = CreateUserRequest(
                name: trimmedName,
                email: trimmedEmail,
                password: trimmedPassword,
                avatar: trimmedAvatarURL
            )
            await viewModel.createUser(payload)
            
        case .update(let user):
            let payload = UpdateUserRequest(
                email: trimmedEmail,
                name: trimmedName
            )
            
            await viewModel.updateUser(id: user.id, payload: payload)
        }
        
        switch viewModel.mutationState {
        case .succeeded(let operation) where operation == expectedMutationOperation:
            viewModel.resetMutationState()
            dismiss()
        case .failed(_, let errorMessage):
            mutationErrorMessage = errorMessage
            isShowingMutationErrorAlert = true
        default:
            break
        }
    }

    private func populateFormIfNeeded() {
        guard !hasPopulatedFromIntent else { return }
        hasPopulatedFromIntent = true

        guard case .update(let user) = intent else { return }

        name = user.name
        email = user.email
        avatarURL = user.avatar ?? "https://picsum.photos/200/200"
    }
    
    var expectedMutationOperation: MutationOperation {
        switch intent {
        case .create:
            return .create
        case .update:
            return .update
        }
    }
    
    var isSavingCurrentIntent: Bool {
        guard case .inProgress(let operation) = viewModel.mutationState else { return false }
        return operation == expectedMutationOperation
    }
}
