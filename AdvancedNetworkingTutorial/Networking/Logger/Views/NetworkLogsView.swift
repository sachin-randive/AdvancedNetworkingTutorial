//
//  NetworkLogsView.swift
//  AdvancedNetworkingTutorial
//
//  Created by Sachin Randive on 03/06/26.
//

import SwiftUI

struct NetworkLogsView: View {
    @Environment(\.dismiss) private var dismiss
    let logStore: NetworkLogStore

    @State private var searchText = ""

    init(logStore: NetworkLogStore) {
        self.logStore = logStore
    }

    private var filteredEntries: [NetworkLogEntry] {
        guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return logStore.entries
        }

        let query = searchText.lowercased()
        return logStore.entries.filter { entry in
            entry.title.lowercased().contains(query) ||
            entry.details.lowercased().contains(query) ||
            (entry.url?.lowercased().contains(query) ?? false)
        }
    }

    var body: some View {
        NavigationStack {
            Group {
                if filteredEntries.isEmpty {
                    ContentUnavailableView(
                        "No Network Logs",
                        systemImage: "bolt.horizontal.circle",
                        description: Text(searchText.isEmpty ? "Make a request to see logs here." : "No logs match your search.")
                    )
                } else {
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 16) {
                            ForEach(filteredEntries) { entry in
                                NavigationLink(value: entry) {
                                    NetworkLogRowView(entry: entry)
                                        .padding(.horizontal)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Network Logs")
            .navigationDestination(for: NetworkLogEntry.self) { entry in
                NetworkLogDetailView(entry: entry)
            }
            .searchable(text: $searchText, prompt: "Search logs")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") { dismiss() }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("Clear") { logStore.clear() }
                        .disabled(logStore.entries.isEmpty)
                }
            }
        }
    }
}

#Preview {
    NetworkLogsView(logStore: NetworkLogStore())
}
