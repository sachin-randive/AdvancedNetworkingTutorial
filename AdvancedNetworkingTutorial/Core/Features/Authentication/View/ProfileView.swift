//
//  ProfileView.swift
//  AdvancedNetworkingTutorial
//
//  Created by Sachin Randive on 08/06/26.
//

import SwiftUI

import Kingfisher

struct ProfileView: View {
    @Environment(AuthenticationManager.self) private var authManager
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack(alignment: .center, spacing: 16) {
                        if let avatar = authManager.authProfile?.avatar, let url = URL(string: avatar) {
                            KFImage(url)
                                .placeholder {
                                    ProgressView()
                                }
                                .resizable()
                                .cancelOnDisappear(true)
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 64, height: 64)
                                .clipShape(Circle())
                        } else {
                            Circle()
                                .fill(Color(.secondarySystemFill))
                                .frame(width: 64, height: 64)
                                .overlay(Image(systemName: "person.fill").foregroundStyle(.secondary))
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text(authManager.authProfile?.name ?? "N/A")
                                .font(.headline)
                            
                            Text(authManager.authProfile?.email ?? "N/A")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                        }

                        Spacer()
                    }
                    .listRowInsets(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
                }
                
                if let profile = authManager.authProfile {
                    Section("Account") {
                        LabeledContent("Name", value: profile.name)
                        LabeledContent("Email", value: profile.email)
                        LabeledContent("Role", value: profile.role.capitalized)
                        LabeledContent("User ID", value: String(profile.id))
                    }
                }
                
                
                Section("Actions") {
                    Button(role: .destructive) {
                        authManager.logout()
                    } label: {
                        Text("Sign Out")
                    }
                }
            }
            .navigationTitle("Profile")
            .listStyle(.insetGrouped)
            .task { await authManager.fertchProfile() }
        }
    }
}

