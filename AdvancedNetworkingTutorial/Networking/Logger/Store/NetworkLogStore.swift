//
//  NetworkLogStore.swift
//  AdvancedNetworkingTutorial
//
//  Created by Sachin Randive on 03/06/26.
//

import Foundation

@MainActor
@Observable
final class NetworkLogStore {
    static let shared = NetworkLogStore()
    
    private(set) var entries: [NetworkLogEntry] = []
    private let maxEntries: Int
    
    init (maxEntries: Int = 300) {
        self.maxEntries = maxEntries
    }
    
    func log(_ entry: NetworkLogEntry) {
        entries.insert(entry, at: 0)
        
        if entries.count > maxEntries {
            entries.removeLast(entries.count - maxEntries)
        }
    }
    
    func clear() {
        entries.removeAll()
    }
}
