//
//  ProductService.swift
//  AdvancedNetworkingTutorial
//
//  Created by Sachin Randive on 25/04/26.
//
import Foundation

protocol ProductServiceProtocol {
    func fetchProducts()async throws -> [Product]
    func createProduct(_ payload: CreateProductRequest) async throws -> Product
    func updateProduct(_ id: Int, with payload: UpdateProductRequest) async throws -> Product
    func deleteProduct(_ id: Int) async throws
}

struct ProductService: ProductServiceProtocol {
    private let client: APIClient
    
    init() {
        client = APIClient(baseURL: URLConstants.fakeStoreURL)
    }
    
    func updateProduct(_ id: Int, with payload: UpdateProductRequest) async throws -> Product {
        let requestModel = try APIRequest<Product>(method: .put, path: .products(.byId(id)), body: payload)
        return try await client.execute(requestModel)
    }
    
    func deleteProduct(_ id: Int) async throws {
        let requestModel = APIRequest<EmptyResponse>(method: .delete, path: .products(.byId(id)))
        let _ = try await client.execute(requestModel)
    }
    
    func createProduct(_ payload: CreateProductRequest) async throws -> Product {
        let requestModel = try APIRequest<Product>(method: .post, path: .products(.list), body: payload)
        return try await client.execute(requestModel)
    }
    
    func fetchProducts() async throws -> [Product] {
        let requestModel = APIRequest<[Product]>(method: .get, path: .products(.list),)
        return try await client.execute(requestModel)
    }
}

struct MockProductService: ProductServiceProtocol {
    func fetchProducts() async throws -> [Product] {
        return Product.mockProducts
    }
    
    func createProduct(_ payload: CreateProductRequest) async throws -> Product {
        return Product.mockProducts.first!
    }
    
    func updateProduct(_ id: Int, with payload: UpdateProductRequest) async throws -> Product {
        return Product.mockProducts.first!
    }
    
    func deleteProduct(_ id: Int) async throws {
            
    }
}
