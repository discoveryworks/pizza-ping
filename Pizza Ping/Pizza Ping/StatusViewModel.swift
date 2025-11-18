//
//  StatusViewModel.swift
//  Pizza Ping
//
//  Created by Claude on 11/18/25.
//

import Foundation
import SwiftUI

/// Manages network status monitoring and UI state
@MainActor
class StatusViewModel: ObservableObject {
    @Published var currentStatus: NetworkStatus = .poor
    @Published var currentLatency: TimeInterval?
    @Published var currentTarget: String = ""
    @Published var lastPingTime: Date?
    @Published var pingHistory: [PingResult] = []
    @Published var isPinging: Bool = false

    private var pingTimer: Timer?
    private let pingInterval: TimeInterval = 300 // 5 minutes default

    init() {
        // Start monitoring on init
        Task {
            await performPing()
            startPeriodicPinging()
        }
    }

    /// Menu bar icon based on current status
    var menuBarIcon: String {
        switch currentStatus {
        case .excellent, .good:
            return "wifi"
        case .slow:
            return "wifi.exclamationmark"
        case .poor:
            return "wifi.slash"
        }
    }

    /// Status color for menu bar indicator
    var statusColor: Color {
        switch currentStatus {
        case .excellent, .good:
            return .green
        case .slow:
            return .yellow
        case .poor:
            return .red
        }
    }

    /// Status emoji for menu bar (colored circle)
    var statusEmoji: String {
        switch currentStatus {
        case .excellent, .good:
            return "🟢"
        case .slow:
            return "🟡"
        case .poor:
            return "🔴"
        }
    }

    /// Formatted latency string
    var latencyString: String {
        guard let latency = currentLatency else {
            return "No connection"
        }
        return String(format: "%.0f ms", latency * 1000)
    }

    /// Server name for display
    var serverName: String {
        // Try to match IP to known target
        if let target = PingTarget.allCases.first(where: { $0.rawValue == currentTarget }) {
            return target.name
        }
        return currentTarget.isEmpty ? "Unknown" : currentTarget
    }

    /// Start periodic background pinging
    func startPeriodicPinging() {
        pingTimer?.invalidate()
        pingTimer = Timer.scheduledTimer(withTimeInterval: pingInterval, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                await self?.performPing()
            }
        }
    }

    /// Stop periodic pinging
    func stopPeriodicPinging() {
        pingTimer?.invalidate()
        pingTimer = nil
    }

    /// Perform a single ping operation
    func performPing() async {
        isPinging = true

        let result = await PingEngine.pingMultipleTargets(Array(PingTarget.allCases))

        currentLatency = result.latency
        currentTarget = result.target
        currentStatus = NetworkStatus(latency: result.latency)
        lastPingTime = result.timestamp
        pingHistory.append(result)

        // Keep only last 100 results
        if pingHistory.count > 100 {
            pingHistory.removeFirst(pingHistory.count - 100)
        }

        isPinging = false
    }

    /// Get average latency over recent history
    var averageLatency: TimeInterval? {
        let recentResults = pingHistory.suffix(10)
        let validLatencies = recentResults.compactMap { $0.latency }

        guard !validLatencies.isEmpty else { return nil }

        return validLatencies.reduce(0, +) / Double(validLatencies.count)
    }

    /// Success rate over recent history
    var successRate: Double {
        let recentResults = pingHistory.suffix(20)
        guard !recentResults.isEmpty else { return 0 }

        let successCount = recentResults.filter { $0.isSuccess }.count
        return Double(successCount) / Double(recentResults.count)
    }
}
