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
                if viewModel.isPinging {
                    ProgressView()
                        .scaleEffect(0.7)
                }
            }

            Divider()

            // Current Status
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Circle()
                        .fill(statusColor)
                        .frame(width: 12, height: 12)
                    Text(viewModel.currentStatus.description)
                        .font(.title3)
                        .fontWeight(.semibold)
                }

                Text(viewModel.latencyString)
                    .font(.system(.body, design: .monospaced))
                    .foregroundStyle(.secondary)

                if let lastPing = viewModel.lastPingTime {
                    Text("Last check: \(lastPing, style: .relative) ago")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Divider()

            // Statistics
            VStack(alignment: .leading, spacing: 6) {
                Text("Statistics")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                if let avgLatency = viewModel.averageLatency {
                    HStack {
                        Text("Avg Latency:")
                            .font(.caption)
                        Spacer()
                        Text(String(format: "%.0f ms", avgLatency * 1000))
                            .font(.system(.caption, design: .monospaced))
                    }
                }

                HStack {
                    Text("Success Rate:")
                        .font(.caption)
                    Spacer()
                    Text(String(format: "%.0f%%", viewModel.successRate * 100))
                        .font(.system(.caption, design: .monospaced))
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

                Button("Quit") {
                    NSApplication.shared.terminate(nil)
                }
                .keyboardShortcut("q")
            }
        }
        .padding()
        .frame(width: 250)
    }

    private var statusColor: Color {
        switch viewModel.currentStatus {
        case .excellent, .good:
            return .green
        case .slow:
            return .yellow
        case .poor:
            return .red
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(StatusViewModel())
}
