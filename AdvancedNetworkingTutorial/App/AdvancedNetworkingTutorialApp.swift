//
//  AdvancedNetworkingTutorialApp.swift
//  AdvancedNetworkingTutorial
//
//  Created by Sachin Randive on 24/04/26.
//

import SwiftUI

@main
struct AdvancedNetworkingTutorialApp: App {
    @State private var authManager = AuthenticationManager(service: AuthenticationService())

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(authManager)
                .environment(\.networkLogPresenter, NetworkLogPresenter())
        }
    }
}
