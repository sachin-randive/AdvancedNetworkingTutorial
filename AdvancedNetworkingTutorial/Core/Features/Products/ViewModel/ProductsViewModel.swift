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
    var mutationState: MutationState = .idle
    
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
        mutationState = .inProgress(.create)
        do {
            let newProduct = try await service.createProduct(payload)
            insertOrStart(with: newProduct)
            mutationState = .succeeded(.create)
        } catch {
            mutationState = .failed(.create, error.localizedDescription)
        }
    }
    
    func updateProduct(_ id: Int, with payload: UpdateProductRequest) async {
        mutationState = .inProgress(.update)
        do {
            let updatedProduct = try await service.updateProduct(id, with: payload)
            replaceItemIfLoaded(with: updatedProduct)
            mutationState = .succeeded(.update)
        } catch {
            mutationState = .failed(.update, error.localizedDescription)
        }
    }
    
    func deletProduct(_ id: Int) async {
        mutationState = .inProgress(.delete)
        do {
            try await service.deleteProduct(id)
            removeItemIfLoaded(id: id)
            mutationState = .succeeded(.delete)
        } catch {
            mutationState = .failed(.delete, error.localizedDescription)
        }
    }
    
    func resetMutationState() {
        mutationState = .idle
    }
}
