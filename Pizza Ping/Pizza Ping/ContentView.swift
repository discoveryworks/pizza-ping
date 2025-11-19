//
//  ContentView.swift
//  Pizza Ping
//
//  Created by Jonathan Berger on 11/18/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: StatusViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                Text("🍕 Pizza Ping")
                    .font(.headline)
                Spacer()
                ProgressView()
                    .scaleEffect(0.7)
                    .opacity(viewModel.isPinging ? 1 : 0)
            }

            Divider()

            // Recent Samples
            VStack(alignment: .leading, spacing: 6) {
                ForEach(Array(viewModel.recentSamples)) { sample in
                    HStack(spacing: 6) {
                        Text(statusEmoji(for: sample))
                            .font(.caption)

                        Text(serverName(for: sample.target))
                            .font(.caption)
                            .fontWeight(.medium)

                        Text("•")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        Text(sample.timestamp, style: .relative)
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        Text("•")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        Text(sample.latency != nil ?
                             String(format: "%.0fms", sample.latency! * 1000) :
                             "No connection")
                            .font(.caption)
                            .foregroundStyle(sample.latency != nil ? .primary : .red)
                    }
                }
            }

            Divider()

            // Actions
            HStack {
                Button("Ping Now") {
                    Task {
                        await viewModel.performPing()
                    }
                }
                .disabled(viewModel.isPinging)

                Spacer()

                Button("Show History") {
                    HistoryLogger.shared.openHistoryFile()
                }
                .font(.caption)

                Button("Quit") {
                    NSApplication.shared.terminate(nil)
                }
                .keyboardShortcut("q")
            }
        }
        .padding()
        .frame(width: 280)
    }

    private func statusEmoji(for sample: PingResult) -> String {
        let status = NetworkStatus(latency: sample.latency)
        switch status {
        case .excellent, .good:
            return "🟢"
        case .slow:
            return "🟡"
        case .poor:
            return "🔴"
        }
    }

    private func serverName(for target: String) -> String {
        if let pingTarget = PingTarget.allCases.first(where: { $0.rawValue == target }) {
            return pingTarget.name
        }
        return target
    }
}

#Preview {
    ContentView()
        .environmentObject(StatusViewModel())
}
