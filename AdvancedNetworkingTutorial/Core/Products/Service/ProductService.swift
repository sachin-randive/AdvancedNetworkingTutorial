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
    private let baseURL: URL = URL(string: "https://api.escuelajs.co/api/v1/products")!
    
    func updateProduct(_ id: Int, with payload: UpdateProductRequest) async throws -> Product {
        let baseURL: URL = URL(string: "https://api.escuelajs.co/api/v1/products/\(id)")!
        var request = URLRequest(url: baseURL)
        request.httpMethod = "PUT"
        
        let body = try JSONEncoder().encode(payload)
        request.httpBody = body
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        guard (200..<300).contains(httpResponse.statusCode) else {
            let bodyString = String(data: data, encoding: .utf8) ?? "<non-UTF8 body>"
            print("Update failed: \(httpResponse.statusCode) – \(bodyString)")
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(Product.self, from: data)
    }
    
    func deleteProduct(_ id: Int) async throws {
        let baseURL: URL = URL(string: "https://api.escuelajs.co/api/v1/products/\(id)")!
        var request = URLRequest(url: baseURL)
        request.httpMethod = "DELETE"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        guard (200..<300).contains(httpResponse.statusCode) else {
            let bodyString = String(data: data, encoding: .utf8) ?? "<non-UTF8 body>"
            print("Update failed: \(httpResponse.statusCode) – \(bodyString)")
            throw URLError(.badServerResponse)
        }
    }
    
    func createProduct(_ payload: CreateProductRequest) async throws -> Product {
        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        
        let body = try JSONEncoder().encode(payload)
        request.httpBody = body
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        guard (200..<300).contains(httpResponse.statusCode) else {
            let bodyString = String(data: data, encoding: .utf8) ?? "<non-UTF8 body>"
            print("Create failed: \(httpResponse.statusCode) – \(bodyString)")
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(Product.self, from: data)
    }
    
    func fetchProducts() async throws -> [Product] {
        let (data, response) = try await URLSession.shared.data(from: baseURL)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        guard 200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode([Product].self, from: data)
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
