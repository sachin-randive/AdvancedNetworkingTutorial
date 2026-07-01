//
//  CryptoCoin.swift
//  AdvancedNetworkingTutorial
//
//  Created by Sachin Randive on 01/07/26.
//

import Foundation

struct CryptoCoin: Decodable, Identifiable, Equatable {
    let id: String
    let symbol: String
    let name: String
    let image: String?
    let currentPrice: Double?
    let marketCap: Double?
    let marketCapRank: Int?
    let totalVolume: Double?
    let high24H: Double?
    let low24H: Double?
    let priceChange24H: Double?
    let priceChangePercentage24H: Double?
    let circulatingSupply: Double?
    let totalSupply: Double?
    let ath: Double?
    let athChangePercentage: Double?
    let athDate: String?
    let atl: Double?
    let atlChangePercentage: Double?
    let atlDate: String?
    let lastUpdated: String?
}

extension CryptoCoin {
    static let mockBitcoin = CryptoCoin(
        id: "bitcoin",
        symbol: "btc",
        name: "Bitcoin",
        image: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png",
        currentPrice: 67890.12,
        marketCap: 1_333_000_000_000,
        marketCapRank: 1,
        totalVolume: 24_500_000_000,
        high24H: 68900.0,
        low24H: 66500.0,
        priceChange24H: 450.21,
        priceChangePercentage24H: 0.67,
        circulatingSupply: 19_600_000,
        totalSupply: 21_000_000,
        ath: 74000.0,
        athChangePercentage: -8.2,
        athDate: "2025-11-20T12:34:56Z",
        atl: 67.81,
        atlChangePercentage: 99999.0,
        atlDate: "2013-07-06T00:00:00Z",
        lastUpdated: "2026-03-12T16:30:00Z"
    )

    static let mockEthereum = CryptoCoin(
        id: "ethereum",
        symbol: "eth",
        name: "Ethereum",
        image: "https://assets.coingecko.com/coins/images/279/large/ethereum.png",
        currentPrice: 3520.45,
        marketCap: 423_000_000_000,
        marketCapRank: 2,
        totalVolume: 12_300_000_000,
        high24H: 3600.0,
        low24H: 3400.0,
        priceChange24H: -25.12,
        priceChangePercentage24H: -0.71,
        circulatingSupply: 120_300_000,
        totalSupply: nil,
        ath: 4900.0,
        athChangePercentage: -28.2,
        athDate: "2025-10-15T09:00:00Z",
        atl: 0.43,
        atlChangePercentage: 818000.0,
        atlDate: "2015-10-20T00:00:00Z",
        lastUpdated: "2026-03-12T16:30:00Z"
    )

    static let mockSolana = CryptoCoin(
        id: "solana",
        symbol: "sol",
        name: "Solana",
        image: "https://assets.coingecko.com/coins/images/4128/large/solana.png",
        currentPrice: 162.34,
        marketCap: 72_000_000_000,
        marketCapRank: 5,
        totalVolume: 3_900_000_000,
        high24H: 170.0,
        low24H: 155.0,
        priceChange24H: 3.12,
        priceChangePercentage24H: 1.96,
        circulatingSupply: 440_000_000,
        totalSupply: 570_000_000,
        ath: 260.0,
        athChangePercentage: -37.6,
        athDate: "2025-12-01T00:00:00Z",
        atl: 0.50,
        atlChangePercentage: 32468.0,
        atlDate: "2020-05-12T00:00:00Z",
        lastUpdated: "2026-03-12T16:30:00Z"
    )

    static let mockCardano = CryptoCoin(
        id: "cardano",
        symbol: "ada",
        name: "Cardano",
        image: "https://assets.coingecko.com/coins/images/975/large/cardano.png",
        currentPrice: 0.84,
        marketCap: 29_000_000_000,
        marketCapRank: 8,
        totalVolume: 980_000_000,
        high24H: 0.90,
        low24H: 0.80,
        priceChange24H: -0.02,
        priceChangePercentage24H: -2.33,
        circulatingSupply: 34_800_000_000,
        totalSupply: 45_000_000_000,
        ath: 3.10,
        athChangePercentage: -72.9,
        athDate: "2021-09-02T00:00:00Z",
        atl: 0.017,
        atlChangePercentage: 4835.0,
        atlDate: "2018-10-01T00:00:00Z",
        lastUpdated: "2026-03-12T16:30:00Z"
    )

    static let mockDogecoin = CryptoCoin(
        id: "dogecoin",
        symbol: "doge",
        name: "Dogecoin",
        image: "https://assets.coingecko.com/coins/images/5/large/dogecoin.png",
        currentPrice: 0.18,
        marketCap: 26_000_000_000,
        marketCapRank: 9,
        totalVolume: 2_100_000_000,
        high24H: 0.20,
        low24H: 0.16,
        priceChange24H: 0.01,
        priceChangePercentage24H: 5.9,
        circulatingSupply: 144_000_000_000,
        totalSupply: nil,
        ath: 0.74,
        athChangePercentage: -75.0,
        athDate: "2021-05-08T00:00:00Z",
        atl: 0.0001,
        atlChangePercentage: 179000.0,
        atlDate: "2015-05-06T00:00:00Z",
        lastUpdated: "2026-03-12T16:30:00Z"
    )

    static var mocks: [CryptoCoin] { [mockBitcoin, mockEthereum, mockSolana, mockCardano, mockDogecoin] }
}

