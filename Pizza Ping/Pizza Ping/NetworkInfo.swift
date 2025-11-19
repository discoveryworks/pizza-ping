//
//  NetworkInfo.swift
//  Pizza Ping
//
//  Created by Claude on 11/18/25.
//

import Foundation
import SystemConfiguration.CaptiveNetwork
import CoreWLAN
import CoreLocation

/// Helper to get current network information
class NetworkInfo {
    private static let locationManager = CLLocationManager()
    private static var hasRequestedPermission = false

    /// Request location permission (needed for WiFi SSID on macOS)
    static func requestLocationPermission() {
        if !hasRequestedPermission {
            hasRequestedPermission = true
            locationManager.requestWhenInUseAuthorization()
        }
    }

    /// Get the current WiFi network name (SSID)
    static func getCurrentSSID() -> String? {
        // Request permission if not done yet
        requestLocationPermission()

        // Use CoreWLAN on macOS
        let client = CWWiFiClient.shared()

        guard let interface = client.interface() else {
            print("DEBUG: client.interface() returned nil")
            return nil
        }

        guard let ssid = interface.ssid() else {
            print("DEBUG: interface.ssid() returned nil - likely needs location permission")
            return nil
        }

        print("DEBUG: Successfully got SSID: \(ssid)")
        return ssid
    }
}
