//
//  ProductService.swift
//  AdvancedNetworkingTutorial
//
//  Created by Sachin Randive on 25/04/26.
//
import Foundation

protocol ProductServiceProtocol {
    func fetchProducts()async throws -> [Product]
}

struct ProductService: ProductServiceProtocol {
    private let baseURL: URL = URL(string:"https://api.escuelajs.co/api/v1/products")!
    func fetchProducts() async throws -> [Product] {
        let (data, response) = try await URLSession.shared.data(from: baseURL)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode([Product].self, from: data)
    }
}

struct MockProductService: ProductServiceProtocol {
    func fetchProducts() async throws -> [Product] {
        return Product.mockProducts
    }
}
