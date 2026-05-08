//
//  ProductsViewModel.swift
//  AdvancedNetworkingTutorial
//
//  Created by Sachin Randive on 24/04/26.
//

import Foundation

@Observable
final class ProductsViewModel: @MainActor ListMutating {
    var loadingState: LoadingState<[Product]> = .idle
    
    private let service: ProductServiceProtocol
    init(service: ProductServiceProtocol) {
        self.service = service
    }
    
    func loadProducts() async {
        loadingState = .loading
        do {
            let products = try await service.fetchProducts()
            loadingState = products.isEmpty ? .empty : .loaded(products)
        } catch {
            loadingState = .error(error.localizedDescription)
            print("DEBUG: Error fetching products: \(error)")
        }
    }
    
    func createProduct(_ payload: CreateProductRequest) async {
        do {
            let newProduct = try await service.createProduct(payload)
            insertOrStart(with: newProduct)
        } catch {
            print("DEBUG: Failed to create product with error: \(error)")
        }
    }
    
    func updateProduct(_ id: Int, with payload: UpdateProductRequest) async {
        do {
            let updatedProduct = try await service.updateProduct(id, with: payload)
            replaceItemIfLoaded(with: updatedProduct)
        } catch {
            print("DEBUG: Failed to update product with error: \(error)")
        }
    }
    
    func deletProduct(_ id: Int) async {
        do {
            try await service.deleteProduct(id)
            removeItemIfLoaded(id: id)
        } catch {
            print("DEBUG: Failed to delet product with error: \(error)")
        }
    }
}
