//
//  ContentView.swift
//  Pizza Ping
//
//  Created I uninstalled the Homebrew version, and am trying to run the Xcode version, and see nothing in my menu bar. by Jonathan Berger on 11/18/25.
//

import SwiftUI

// Helper view for displaying a single sample row
struct SampleRowView: View {
    let sample: PingResult

    var body: some View {
        HStack(spacing: 4) {
            // Column 1: Status emoji
            Text(statusEmoji)
                .font(.system(.caption, design: .monospaced))
                .frame(width: 16, alignment: .leading)

            // Column 2: Time
            Text(sample.timestamp, format: .dateTime.hour().minute())
                .font(.system(.caption, design: .monospaced))
                .foregroundStyle(.secondary)
                .frame(width: 52, alignment: .leading)

            // Column 3: Latency
            Text(sample.latency != nil ?
                 String(format: "%3.0fms", sample.latency! * 1000) :
                 " --ms")
                .font(.system(.caption, design: .monospaced))
                .foregroundStyle(sample.latency != nil ? .primary : Color.red)
                .frame(width: 38, alignment: .trailing)

            // Column 4: Server (fixed width for alignment)
            Text(serverName)
                .font(.system(.caption, design: .monospaced))
                .fontWeight(.medium)
                .frame(width: 70, alignment: .leading)

            // Column 5: Arrow
            Text("→")
                .font(.system(.caption, design: .monospaced))
                .foregroundStyle(.secondary)

            // Column 6: Network name (flexible)
            Text(truncatedNetworkName)
                .font(.system(.caption, design: .monospaced))
                .foregroundStyle(.secondary)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var truncatedNetworkName: String {
        guard let networkName = sample.networkName else { return "" }

        // Smart truncation: [first 8]…[last 4] for names > 12 chars
        if networkName.count > 12 {
            let start = String(networkName.prefix(8))
            let end = String(networkName.suffix(4))
            return "\(start)…\(end)"
        }
        return networkName
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
        case .disconnected:
            return "🚫"
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
        .frame(width: 320)
    }
}

#Preview {
    ContentView()
        .environmentObject(StatusViewModel())
}
