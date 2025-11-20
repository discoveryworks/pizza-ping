//
//  ContentView.swift
//  Pizza Ping Watch Watch App
//
//  Created by Jonathan Berger on 11/20/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = StatusViewModel()

    var body: some View {
        VStack(spacing: 8) {
            // Large status indicator
            Text(viewModel.statusEmoji)
                .font(.system(size: 60))

            // Status text
            Text(viewModel.currentStatus.description)
                .font(.headline)

            // Latency
            Text(viewModel.latencyString)
                .font(.system(.title3, design: .monospaced))
                .foregroundStyle(.secondary)

            // Last check time
            if let lastPing = viewModel.lastPingTime {
                Text(lastPing, style: .relative)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            Spacer()

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
                }
            }
            .disabled(viewModel.isPinging)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
