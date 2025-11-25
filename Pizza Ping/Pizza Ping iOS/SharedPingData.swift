//
//  SharedPingData.swift
//  Pizza Ping
//
//  Created by Claude on 11/20/25.
//

import Foundation

/// Shared storage for ping data between app and complication
class SharedPingData {
    private static let defaults = UserDefaults(suiteName: "group.works.discovery.Pizza-Ping")

    static var currentStatus: NetworkStatus {
        get {
            guard let rawValue = defaults?.string(forKey: "currentStatus"),
                  let status = NetworkStatus(rawValue: rawValue) else {
                return .poor
            }
            return status
        }
        set {
            defaults?.set(newValue.rawValue, forKey: "currentStatus")
        }
    }

    static var currentLatency: TimeInterval? {
        get {
            guard let latency = defaults?.double(forKey: "currentLatency"), latency > 0 else {
                return nil
            }
            return latency
        }
        set {
            if let newValue = newValue {
                defaults?.set(newValue, forKey: "currentLatency")
            } else {
                defaults?.removeObject(forKey: "currentLatency")
            }
        }
    }

    /// Save current ping status for widget
    static func save(status: NetworkStatus, latency: TimeInterval?) {
        currentStatus = status
        currentLatency = latency
    }
}
