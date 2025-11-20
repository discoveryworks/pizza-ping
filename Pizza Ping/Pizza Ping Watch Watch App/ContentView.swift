//
//  ContentView.swift
//  Pizza Ping Watch Watch App
//
//  Created by Jonathan Berger on 11/20/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = StatusViewModel()
    @State private var isPressing = false

    var body: some View {
        VStack(spacing: 0) {
            // Top section: Current status (long-pressable)
            VStack(spacing: 6) {
                // Top row: Hero pizza/status + Stats
                HStack(alignment: .top, spacing: 8) {
                    // Left: Large pizza + status (quarter screen)
                    HStack(spacing: 2) {
                        Text("🍕")
                            .font(.system(size: 40))
                        Text(viewModel.statusEmoji)
                            .font(.system(size: 40))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    // Right: Stats (three monospace lines)
                    VStack(alignment: .trailing, spacing: 2) {
                        Text(viewModel.latencyString)
                            .font(.system(.body, design: .monospaced))
                            .fontWeight(.semibold)

                        if let lastPing = viewModel.lastPingTime {
                            Text(lastPing, format: .dateTime.hour().minute())
                                .font(.system(.caption, design: .monospaced))
                                .foregroundStyle(.secondary)
                        }

                        Text(viewModel.serverName)
                            .font(.system(.caption, design: .monospaced))
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }

                // Bottom row: Network name (full width)
                if let networkName = viewModel.currentNetworkName {
                    Text(networkName)
                        .font(.system(.caption2, design: .monospaced))
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(8)
            .background(isPressing ? Color.gray.opacity(0.3) : Color.clear)
            .overlay(
                isPressing ?
                    Text("Release to ping...")
                        .font(.caption2)
                        .foregroundStyle(.white)
                        .padding(4)
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(4)
                        .transition(.opacity)
                    : nil
            )
            .onLongPressGesture(minimumDuration: 1.5, pressing: { pressing in
                withAnimation {
                    isPressing = pressing
                }
            }, perform: {
                Task {
                    await viewModel.performPing()
                }
            })

            Divider()

            // Bottom section: Scrollable ping history
            ScrollView {
                PingHistoryGrid(pingHistory: viewModel.pingHistory)
                    .padding(.vertical, 8)
            }
        }
    }
}

// Grid showing ping history with time markers
struct PingHistoryGrid: View {
    let pingHistory: [PingResult]

    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 20), spacing: 4)], spacing: 4) {
            ForEach(Array(historyWithMarkers.enumerated()), id: \.offset) { _, item in
                switch item {
                case .clock(let emoji):
                    Text(emoji)
                        .font(.caption2)
                case .status(let emoji):
                    Text(emoji)
                        .font(.caption)
                }
            }
        }
        .padding(.horizontal, 4)
    }

    enum HistoryItem {
        case status(String)
        case clock(String)
    }

    private var historyWithMarkers: [HistoryItem] {
        var items: [HistoryItem] = []
        var lastHourMarker: Int?

        for result in pingHistory.reversed() {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.hour, .minute], from: result.timestamp)
            let hour = components.hour ?? 0
            let minute = components.minute ?? 0

            // Add clock marker every 30 minutes (on the hour and half hour)
            if minute == 0 || minute == 30 {
                let markerKey = hour * 100 + minute
                if lastHourMarker != markerKey {
                    lastHourMarker = markerKey
                    items.append(.clock(clockEmoji(hour: hour, minute: minute)))
                }
            }

            // Add status emoji
            let status = NetworkStatus(latency: result.latency)
            let emoji: String
            switch status {
            case .excellent, .good: emoji = "🟢"
            case .slow: emoji = "🟡"
            case .poor: emoji = "🔴"
            case .disconnected: emoji = "🚫"
            }
            items.append(.status(emoji))
        }

        return items
    }

    private func clockEmoji(hour: Int, minute: Int) -> String {
        // Clock emoji based on hour (🕐-🕧)
        let baseHour = hour % 12
        if minute == 0 {
            // On the hour: 🕐🕑🕒🕓🕔🕕🕖🕗🕘🕙🕚🕛
            let clocks = ["🕛", "🕐", "🕑", "🕒", "🕓", "🕔", "🕕", "🕖", "🕗", "🕘", "🕙", "🕚"]
            return clocks[baseHour]
        } else {
            // Half hour: 🕜🕝🕞🕟🕠🕡🕢🕣🕤🕥🕦🕧
            let clocks = ["🕧", "🕜", "🕝", "🕞", "🕟", "🕠", "🕡", "🕢", "🕣", "🕤", "🕥", "🕦"]
            return clocks[baseHour]
        }
    }
}

#Preview {
    ContentView()
}
