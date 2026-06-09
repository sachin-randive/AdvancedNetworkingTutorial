//
//  LoginView.swift
//  AdvancedNetworkingTutorial
//
//  Created by Sachin Randive on 08/06/26.
//

import SwiftUI

struct LoginView: View {
    @Environment(AuthenticationManager.self) private var authManager
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()

                TextField("Email", text: $email)
                    .font(.subheadline)
                    .padding(12)
                    .background(Color(.systemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .frame(maxWidth: .infinity)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled()

                SecureField("Password", text: $password)
                    .font(.subheadline)
                    .padding(12)
                    .background(Color(.systemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .frame(maxWidth: .infinity)

                Button {
                    Task { await authManager.login(payload: LoginRequest(email: email, password: password)) }
                } label: {
                    Text("Sign In")
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(.blue)
                        .foregroundStyle(.white)
                        .font(.headline)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.vertical)
                .disabled(email.isEmpty || password.isEmpty)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Sign In")
        }
    }
}
