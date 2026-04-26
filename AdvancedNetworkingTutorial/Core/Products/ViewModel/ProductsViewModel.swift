//
//  ProductsViewModel.swift
//  AdvancedNetworkingTutorial
//
//  Created by Sachin Randive on 24/04/26.
//

import Foundation

@Observable
final class ProductsViewModel {
    var products: [Product] = []
    
    private let service: ProductServiceProtocol
    init(service: ProductServiceProtocol) {
        self.service = service
    }
    
    func loadProducts() async {
        do {
            self.products = try await service.fetchProducts()
        } catch {
            print("DEBUG: Error fetching products: \(error)")
        }
    }
}
