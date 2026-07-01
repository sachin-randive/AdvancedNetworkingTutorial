//
//  CoinRowView.swift
//  AdvancedNetworkingTutorial
//
//  Created by Sachin Randive on 01/07/26.
//

import SwiftUI

struct CoinRowView: View {
    let coin: CryptoCoin
    
    var body: some View {
        HStack(spacing: 12) {
            CoinIconView(urlString: coin.image)
                .frame(width: 40, height: 40)

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(coin.name)
                        .font(.headline)
                        .lineLimit(1)
                        .foregroundStyle(.primary)
                }
                Text(coin.symbol.uppercased())
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: 8)

            VStack(alignment: .trailing, spacing: 6) {
                Text(coin.currentPrice?.formattedCurrency() ?? "$0.00")
                    .font(.headline)
                    .foregroundStyle(.primary)

                ChangePill(percentage: coin.priceChangePercentage24H)
            }
        }
        .padding(12)
        .background {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        }
        .overlay {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .strokeBorder(.separator.opacity(0.15))
        }
    }
}


