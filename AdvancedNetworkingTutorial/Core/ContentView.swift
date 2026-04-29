//
//  ContentView.swift
//  AdvancedNetworkingTutorial
//
//  Created by Sachin Randive on 24/04/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("Products", systemImage: "cart") {
                ProductsView()
            }
            
            Tab("Users", systemImage: "person") {
               UserListView()
            }
        }
    }
}

#Preview {
    ContentView()
}
