//
//  ContentView.swift
//  Pizza Ping iOS
//
//  Created by Jonathan Berger on 11/20/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = StatusViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Large status indicator
                Text(viewModel.statusEmoji)
                    .font(.system(size: 80))

                // Status
                VStack(spacing: 4) {
                    Text(viewModel.currentStatus.description)
                        .font(.title2)
                        .fontWeight(.semibold)

                    Text(viewModel.latencyString)
                        .font(.system(.title3, design: .monospaced))
                        .foregroundStyle(.secondary)
                }

                // Recent samples
                List {
                    ForEach(viewModel.pingHistory.suffix(10).reversed()) { sample in
                        HStack {
                            Text(statusEmoji(for: sample))
                            Text(serverName(for: sample.target))
                                .fontWeight(.medium)
                            Spacer()
                            Text(sample.latency != nil ?
                                 String(format: "%.0fms", sample.latency! * 1000) :
                                 "Failed")
                                .font(.system(.body, design: .monospaced))
                                .foregroundStyle(.secondary)
                        }
                        .font(.callout)
                    }
                }

                // Ping button
                Button {
                    Task {
                        await viewModel.performPing()
                    }
                } label: {
                    if viewModel.isPinging {
                        ProgressView()
                    } else {
                        Text("Ping Now")
                            .fontWeight(.semibold)
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(viewModel.isPinging)
            }
            .navigationTitle("🍕 Pizza Ping")
            .padding()
        }
    }

    private func statusEmoji(for sample: PingResult) -> String {
        let status = NetworkStatus(latency: sample.latency)
        switch status {
        case .excellent, .good: return "🟢"
        case .slow: return "🟡"
        case .poor: return "🔴"
        case .disconnected: return "🚫"
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
}
