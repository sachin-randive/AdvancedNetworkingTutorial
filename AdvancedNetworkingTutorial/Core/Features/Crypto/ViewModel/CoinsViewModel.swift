//
//  CoinsViewModel.swift
//  AdvancedNetworkingTutorial
//
//  Created by Sachin Randive on 01/07/26.
//

import Foundation

@Observable @MainActor
final class CoinsViewModel {
    var loadingState: LoadingState<[CryptoCoin]> = .loading
    
    private let service: CoinGeckoServiceProtocol

    init(service: CoinGeckoServiceProtocol) {
        self.service = service
    }
    
    func fetchCoins() async {
        do {
            let coins = try await service.fetchMarkets(order: .marketCapDesc, perPage: 50, page: 1)
            loadingState = coins.isEmpty ? .empty : .loaded(coins)
        } catch {
            print("DEBUG: Error \(error)")
            loadingState = .error(error.localizedDescription)
        }
    }
    
    func refreshCoins() async {
        do {
            let coins = try await service.fetchMarkets(order: .marketCapDesc, perPage: 50, page: 1)
            loadingState = coins.isEmpty ? .empty : .loaded(coins)
        } catch {
            loadingState = .error(error.localizedDescription)
        }
    }
}
