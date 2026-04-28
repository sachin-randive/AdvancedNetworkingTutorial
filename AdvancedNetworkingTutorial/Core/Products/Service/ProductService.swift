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
    private let baseURL: URL = URL(string: "https://api.escuelajs.co/api/v1/")!
    
    func updateProduct(_ id: Int, with payload: UpdateProductRequest) async throws -> Product {
        let requestModel = try APIRequest<Product>(method: .put, path: .products(.byId(id)), body: payload)
        return try await execute(requestModel)
    }
    
    func deleteProduct(_ id: Int) async throws {
        let requestModel = APIRequest<EmptyResponse>(method: .delete, path: .products(.byId(id)))
        let _ = try await execute(requestModel)
    }
    
    func createProduct(_ payload: CreateProductRequest) async throws -> Product {
        let requestModel = try APIRequest<Product>(method: .post, path: .products(.list), body: payload)
        return try await execute(requestModel)
    }
    
    func fetchProducts() async throws -> [Product] {
        let requestModel = APIRequest<[Product]>(method: .get, path: .products(.list),)
        return try await execute(requestModel)
    }
    
    private func execute<Response>(_ requestModel: APIRequest<Response>) async throws -> Response {
        let request = try requestModel.makeURLRequest(baseURL: baseURL)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        guard 200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(Response.self, from: data)
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
