//
//  ProfileView.swift
//  AdvancedNetworkingTutorial
//
//  Created by Sachin Randive on 08/06/26.
//

import SwiftUI

import Kingfisher

struct ProfileView: View {
    let user: User
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack(alignment: .center, spacing: 16) {
                        if let avatar = user.avatar, let url = URL(string: avatar) {
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
                            Text(user.name)
                                .font(.headline)
                            
                            Text(user.email)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                        }

                        Spacer()
                    }
                    .listRowInsets(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
                }

                Section("Account") {
                    LabeledContent("Name", value: user.name)
                    LabeledContent("Email", value: user.email)
                    LabeledContent("Role", value: user.role?.capitalized ?? "Unknown")
                    LabeledContent("User ID", value: String(user.id))
                }

                Section("Actions") {
                    Button(role: .destructive) {
                        print("Logout here..")
                    } label: {
                        Text("Sign Out")
                    }
                }
            }
            .navigationTitle("Profile")
            .listStyle(.insetGrouped)
            .task {
               print("Load user profile here..")
            }
        }
    }
}

