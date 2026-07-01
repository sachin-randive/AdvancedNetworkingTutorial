//
//  CoinGeckoService.swift
//  AdvancedNetworkingTutorial
//
//  Created by Sachin Randive on 01/07/26.
//

import Foundation

protocol CoinGeckoServiceProtocol {
    func fetchMarkets(order: MarketsOrder, perPage: Int, page: Int) async throws -> [CryptoCoin]
}

struct CoinGeckoService: CoinGeckoServiceProtocol {
    let client: APIClient
    
    init() {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        self.client = APIClient(baseURL: URLConstants.coinGeckoURL, decoder: decoder)
    }
    
    func fetchMarkets(order: MarketsOrder, perPage: Int = 50, page: Int = 1) async throws -> [CryptoCoin] {
        let request = try marketsRequest(order: order, perPage: perPage, page: 1)
        return try await client.execute(request)
    }
    
    private func marketsRequest(order: MarketsOrder, perPage: Int, page: Int) throws -> APIRequest<[CryptoCoin]> {
        let items: [URLQueryItem] = [
            .init(name: "vs_currency", value: "usd"),
            .init(name: "order", value: order.rawValue),
            .init(name: "per_page", value: String(max(1, min(250, perPage)))),
            .init(name: "page", value: String(max(1, page))),
            .init(name: "sparkline", value: "false"),
            .init(name: "price_change_percentage", value: "24h")
        ]
        
        return APIRequest<[CryptoCoin]>(method: .get, path: .crypto(.markets), queryItems: items)
    }
}
