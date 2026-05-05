//
//  ProductsViewModel.swift
//  AdvancedNetworkingTutorial
//
//  Created by Sachin Randive on 24/04/26.
//

import Foundation

@Observable @MainActor
final class ProductsViewModel {
    // var products: [Product] = []
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
            insertorstartProducts(with: newProduct)
        } catch {
            print("DEBUG: Failed to create product with error: \(error)")
        }
    }
    
    func updateProduct(_ id: Int, with payload: UpdateProductRequest) async {
        do {
            let updatedProduct = try await service.updateProduct(id, with: payload)
            replaceProductIfLoaded(with: updatedProduct)
        } catch {
            print("DEBUG: Failed to update product with error: \(error)")
        }
    }
    
    func deletProduct(_ id: Int) async {
        do {
            try await service.deleteProduct(id)
            replaceProductIfLoaded(id: id)
        } catch {
            print("DEBUG: Failed to delet product with error: \(error)")
        }
    }
    private func insertorstartProducts(with product: Product) {
        switch loadingState {
        case .loaded(var  products):
            products.insert(product, at: 0)
            loadingState = .loaded(products)
        default:
            loadingState = .loaded([product])
        }
    }
    
    private func replaceProductIfLoaded(with product: Product) {
        guard case .loaded(var products) = loadingState else { return }
        guard let index = products.firstIndex(where: { $0.id == product.id }) else { return }
        products[index] = product
        loadingState = .loaded(products)
    }
    private func replaceProductIfLoaded(id: Int) {
        guard case .loaded(var products) = loadingState else { return }
        guard let index = products.firstIndex(where: { $0.id == id }) else { return }
        products.remove(at: index)
        loadingState = .loaded(products)
    }
}
