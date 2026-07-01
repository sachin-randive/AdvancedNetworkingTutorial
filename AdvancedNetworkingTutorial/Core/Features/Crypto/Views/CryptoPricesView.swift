//
//  CryptoPricesView.swift
//  AdvancedNetworkingTutorial
//
//  Created by Sachin Randive on 01/07/26.
//

import SwiftUI

struct CryptoPricesView: View {
    @State private var viewModel = CoinsViewModel(service: CoinGeckoService())

    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.loadingState {
                case .loading, .idle:
                    ProgressView()
                case .empty:
                    Text("No coins available.")
                case .error(let error):
                    ContentUnavailableView {
                        Label("Couldn’t Load Markets", systemImage: "wifi.exclamationmark")
                    } description: {
                        Text(error)
                    } actions: {
                        Button {
                            Task { await viewModel.fetchCoins() }
                        } label: {
                            Text("Retry")
                                .font(.headline)
                                .foregroundStyle(.white)
                                .frame(width: 360, height: 48)
                                .background(.blue)
                                .clipShape(.capsule)
                        }
                    }
                case .loaded(let coins):
                    List {
                        ForEach(coins) { coin in
                            CoinRowView(coin: coin)
                                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                                .listRowSeparator(.hidden)
                                .background(Color.clear)
                        }
                    }
                    .refreshable { await viewModel.refreshCoins() }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Markets")
            .networkLogsSheet()
            .task { await viewModel.fetchCoins() }
        }
    }
}

#Preview {
    ContentView()
}

