//
//  NetworkInfo.swift
//  Pizza Ping
//
//  Created by Claude on 11/18/25.
//

import Foundation
import SystemConfiguration.CaptiveNetwork
import CoreWLAN

/// Helper to get current network information
class NetworkInfo {
    /// Get the current WiFi network name (SSID)
    static func getCurrentSSID() -> String? {
        // Use CoreWLAN on macOS
        guard let interface = CWWiFiClient.shared().interface() else {
            return nil
        }
        return interface.ssid()
    }
}
