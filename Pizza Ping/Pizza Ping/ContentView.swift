//
//  ContentView.swift
//  Pizza Ping
//
//  Created by Jonathan Berger on 11/18/25.
//

import SwiftUI

// Helper view for displaying a single sample row
struct SampleRowView: View {
    let sample: PingResult

    var body: some View {
        HStack(spacing: 6) {
            Text(statusEmoji)
                .font(.caption)

            if let networkName = sample.networkName {
                Text(networkName)
                    .font(.caption)
                    .fontWeight(.semibold)

                Text("•")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Text(serverName)
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
                .foregroundStyle(sample.latency != nil ? .primary : Color.red)
        }
    }

    private var statusEmoji: String {
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

    private var serverName: String {
        if let pingTarget = PingTarget.allCases.first(where: { $0.rawValue == sample.target }) {
            return pingTarget.name
        }
        return sample.target
    }
}

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
                ForEach(viewModel.pingHistory.suffix(3).reversed()) { sample in
                    SampleRowView(sample: sample)
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
}

#Preview {
    ContentView()
        .environmentObject(StatusViewModel())
}
