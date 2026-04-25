//
//  ProductsView.swift
//  AdvancedNetworkingTutorial
//
//  Created by Sachin Randive on 24/04/26.
//

import SwiftUI

@MainActor
struct ProductsView: View {
    @State private var viewModel = ProductsViewModel()
    @State private var isShowingCreateSheet = false
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.products) { product in
                        NavigationLink(value: product) {
                            ProductCardView(product: product)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
            .navigationTitle(Text("Products"))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isShowingCreateSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .navigationDestination(for: Product.self) { product in
                ProductDetailView(product: product)
            }
            .refreshable { await viewModel.loadProducts() }
            .task { await viewModel.loadProducts() }
        }
    }
}

#Preview {
    ProductsView()
}
