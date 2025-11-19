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
        guard let client = CWWiFiClient.shared() else {
            print("DEBUG: CWWiFiClient.shared() returned nil")
            return nil
        }

        guard let interface = client.interface() else {
            print("DEBUG: client.interface() returned nil")
            return nil
        }

        guard let ssid = interface.ssid() else {
            print("DEBUG: interface.ssid() returned nil")
            return nil
        }

        print("DEBUG: Successfully got SSID: \(ssid)")
        return ssid
    }
}
