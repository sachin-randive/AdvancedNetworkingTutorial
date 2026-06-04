//
//  NetworkLogRowView.swift
//  AdvancedNetworkingTutorial
//
//  Created by Sachin Randive on 03/06/26.
//

import SwiftUI

struct NetworkLogRowView: View {
    let entry: NetworkLogEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Text(entry.kind.rawValue.uppercased())
                    .font(.caption2.weight(.bold))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(kindColor.opacity(0.14))
                    .foregroundStyle(kindColor)
                    .clipShape(Capsule())

                if let method = entry.method {
                    Text(method.rawValue)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                }

                Spacer()

                if let statusCode = entry.statusCode {
                    Text("\(statusCode)")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(statusColor(statusCode))
                }

                if let durationMs = entry.durationMs {
                    Text("\(durationMs)ms")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Text(entry.title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.primary)
                .lineLimit(2)

            if let url = entry.url {
                Text(url)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .truncationMode(.middle)
            }

            Text(entry.timestamp, style: .time)
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
    }

    private var kindColor: Color {
        switch entry.kind {
        case .request:
            return .blue
        case .response:
            return .green
        case .error:
            return .red
        }
    }

    private func statusColor(_ code: Int) -> Color {
        switch code {
        case 200..<300: return .green
        case 300..<500: return .orange
        default: return .red
        }
    }
}

#Preview {
    NetworkLogRowView(entry: NetworkLogEntry.mocks[0])
}

