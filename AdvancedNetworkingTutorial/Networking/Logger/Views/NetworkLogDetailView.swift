//
//  NetworkLogDetailView.swift
//  AdvancedNetworkingTutorial
//
//  Created by Sachin Randive on 03/06/26.
//

import SwiftUI
import UIKit

struct NetworkLogDetailView: View {
    let entry: NetworkLogEntry
    @State private var didCopyCurl = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text(entry.title)
                    .font(.headline)

                if let url = entry.url {
                    labeledSection("URL", value: url)
                }
                
                if let method = entry.method {
                    labeledSection("Method", value: method.rawValue)
                }

                if let statusCode = entry.statusCode {
                    labeledSection("Status", value: String(statusCode))
                }

                if let durationMs = entry.durationMs {
                    labeledSection("Duration", value: "\(durationMs)ms")
                }

                if let fetchSource = entry.fetchSource {
                    labeledSection("Fetch Source", value: fetchSource)
                }

                if let security = entry.security {
                    labeledSection(
                        "Security",
                        value: security.tlsPinningEnabled ? "TLS pinning enabled" : "TLS pinning disabled"
                    )
                    labeledSection("TLS Pinning Result", value: security.tlsPinningResult)

                    if let failureReason = security.tlsPinningFailureReason {
                        labeledSection("TLS Failure Reason", value: failureReason, monospaced: true)
                    }
                }
                
                labeledSection("Details", value: entry.details, monospaced: true)

                if let curlCommand = entry.curlCommand {
                    labeledSection("cURL", value: curlCommand, monospaced: true)
                    
                    Button {
                        UIPasteboard.general.string = curlCommand
                        didCopyCurl = true
                    } label: {
                        Label("Copy as cURL", systemImage: "doc.on.doc")
                            .frame(maxWidth: .infinity)
                            .frame(height: 40)
                            .background(.blue)
                            .foregroundStyle(.white)
                            .clipShape(.capsule)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Log Detail")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Copied", isPresented: $didCopyCurl) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("cURL command copied to clipboard.")
        }
    }

    @ViewBuilder
    private func labeledSection(_ label: String, value: String, monospaced: Bool = false) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)

            Text(value)
                .font(monospaced ? .footnote.monospaced() : .footnote)
                .foregroundStyle(.primary)
                .textSelection(.enabled)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color(.secondarySystemBackground))
                )
        }
    }

}

#Preview {
    NetworkLogDetailView(entry: NetworkLogEntry.mocks[1])
}
 
