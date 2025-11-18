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

            // Main Status
            VStack(alignment: .leading, spacing: 8) {
                // Status line with emoji indicator
                Text("\(viewModel.statusEmoji) Network signal is \(viewModel.currentStatus.description.lowercased()). (\(viewModel.latencyString))")
                    .font(.body)

                // Last checked line
                if let lastPing = viewModel.lastPingTime {
                    Text("Last checked \(viewModel.serverName) \(lastPing, style: .relative) ago")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                // Stats on one line
                HStack(spacing: 16) {
                    if let avgLatency = viewModel.averageLatency {
                        Text("avg \(String(format: "%.0f", avgLatency * 1000))ms")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Text("\(String(format: "%.0f", viewModel.successRate * 100))% success")
                        .font(.caption)
                        .foregroundStyle(.secondary)
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
        .frame(width: 280)
    }
}

#Preview {
    ContentView()
        .environmentObject(StatusViewModel())
}
