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
    
    func loadProducts() async throws {
        self.products = Product.mockProducts
    }
}
