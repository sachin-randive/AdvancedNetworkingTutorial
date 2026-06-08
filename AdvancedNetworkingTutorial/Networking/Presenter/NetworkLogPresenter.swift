//
//  NetworkLogPresenter.swift
//  AdvancedNetworkingTutorial
//
//  Created by Sachin Randive on 08/06/26.
//

import Foundation
import SwiftUI

@Observable @MainActor
final class NetworkLogPresenter {
    var isPresented: Bool = false
    
    func show() { isPresented = true }
    func hide() { isPresented = false }
}

private struct NetworkLogsPresenterKey: EnvironmentKey {
    static let defaultValue: NetworkLogPresenter? = nil
}

extension EnvironmentValues {
    var networkLogPresenter: NetworkLogPresenter? {
        get { self[NetworkLogsPresenterKey.self] }
        set { self[NetworkLogsPresenterKey.self] = newValue }
    }
}

private struct NetworkLogsSheetModifier: ViewModifier {
    @Environment(\.networkLogPresenter) var presenter
    func body(content: Content) -> some View {
        if let presenter {
            @Bindable var presenter = presenter
            
            content
                .sheet(isPresented: $presenter.isPresented) {
                    NetworkLogsView(logStore: .shared)
                        .onDisappear { presenter.hide() }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        NetworkLogsToolbarButton()
                    }
                }
        } else {
            content
        }
    }
}

extension View {
    func networkLogsSheet() -> some View {
        modifier(NetworkLogsSheetModifier())
    }
}

private struct NetworkLogsToolbarButton: View {
    @Environment(\.networkLogPresenter) private var presenter

    var body: some View {
        Button {
            presenter?.show()
        } label: {
            Image(systemName: "bolt.horizontal.circle")
        }
        .disabled(presenter == nil)
    }
}

