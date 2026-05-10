//
//  MutationState.swift
//  AdvancedNetworkingTutorial
//
//  Created by Sachin Randive on 10/05/26.
//

import Foundation

enum MutationState {
    case idle
    case inProgress(MutationOperation)
    case succeeded(MutationOperation)
    case failed(MutationOperation, String)
}

enum MutationOperation {
    case create
    case update
    case delete
}
