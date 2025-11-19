//
//  PingResult.swift
//  Pizza Ping
//
//  Created by Claude on 11/18/25.
//

import Foundation

/// Represents a single ping result
struct PingResult: Identifiable, Codable {
    let id: UUID
    let timestamp: Date
    let latency: TimeInterval? // nil if ping failed
    let target: String
    let networkName: String? // WiFi network name (SSID)

    init(target: String, latency: TimeInterval?, networkName: String? = nil) {
        self.id = UUID()
        self.timestamp = Date()
        self.target = target
        self.latency = latency
        self.networkName = networkName
    }

    var isSuccess: Bool {
        latency != nil
    }
}

/// Network status based on ping results
enum NetworkStatus {
    case excellent     // < 50ms
    case good          // 50-150ms
    case slow          // 150-300ms
    case poor          // > 300ms
    case disconnected  // Failed/no connection

    init(latency: TimeInterval?) {
        guard let latency = latency else {
            self = .disconnected
            return
        }

        switch latency {
        case 0..<0.05:
            self = .excellent
        case 0.05..<0.15:
            self = .good
        case 0.15..<0.3:
            self = .slow
        default:
            self = .poor
        }
    }

    var color: String {
        switch self {
        case .excellent: return "green"
        case .good: return "green"
        case .slow: return "yellow"
        case .poor: return "red"
        case .disconnected: return "none"
        }
    }

    var description: String {
        switch self {
        case .excellent: return "Excellent"
        case .good: return "Good"
        case .slow: return "Slow"
        case .poor: return "Poor"
        case .disconnected: return "Disconnected"
        }
    }
}

/// Public ping targets
enum PingTarget: String, CaseIterable {
    case cloudflare = "1.1.1.1"
    case google = "8.8.8.8"
    case quad9 = "9.9.9.9"

    var name: String {
        switch self {
        case .cloudflare: return "Cloudflare DNS"
        case .google: return "Google DNS"
        case .quad9: return "Quad9 DNS"
        }
    }
}
