//
//  CoinIconView.swift
//  AdvancedNetworkingTutorial
//
//  Created by Sachin Randive on 01/07/26.
//

import SwiftUI
import Kingfisher

struct CoinIconView: View {
    let urlString: String?
    @State private var didFail = false

    var body: some View {
        Group {
            if let urlString, let url = URL(string: urlString) {
                if didFail {
                    fallbackIcon
                } else {
                    KFImage(url)
                        .placeholder {
                            ZStack {
                                Circle().fill(.quaternary)
                                ProgressView().scaleEffect(0.8)
                            }
                        }
                        .retry(maxCount: 2, interval: .seconds(1))
                        .onSuccess { _ in
                            didFail = false
                        }
                        .onFailure { _ in
                            didFail = true
                        }
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                }
            } else {
                fallbackIcon
            }
        }
        .onChange(of: urlString) { _, _ in
            print("DEBUG: Reloading images..")
            didFail = false
        }
        .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
    }

    private var fallbackIcon: some View {
        ZStack {
            Circle().fill(.quaternary)
            Image(systemName: "bitcoinsign.circle.fill")
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.secondary)
        }
    }
}
