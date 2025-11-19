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

        // Check location authorization status
        let status = locationManager.authorizationStatus
        print("DEBUG: Location authorization status: \(status.rawValue)")

        // Use CoreWLAN on macOS
        let client = CWWiFiClient.shared()

        guard let interface = client.interface() else {
            print("DEBUG: client.interface() returned nil")
            return nil
        }

        print("DEBUG: Interface name: \(interface.interfaceName ?? "unknown")")
        print("DEBUG: Power on: \(interface.powerOn())")

        guard let ssid = interface.ssid() else {
            print("DEBUG: interface.ssid() returned nil")
            print("DEBUG: Location auth status: \(status.rawValue)")
            print("DEBUG: If status is not 'authorized', go to System Settings → Privacy & Security → Location Services")
            return nil
        }

        print("DEBUG: Successfully got SSID: \(ssid)")
        return ssid
    }
}
