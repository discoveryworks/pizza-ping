//
//  NetworkInfo.swift
//  Pizza Ping
//
//  Created by Claude on 11/18/25.
//

import Foundation
#if os(macOS)
import SystemConfiguration.CaptiveNetwork
import CoreWLAN
import CoreLocation
#elseif os(iOS) || os(watchOS)
import NetworkExtension
#endif

/// Helper to get current network information
class NetworkInfo {
    #if os(macOS)
    private static let locationManager = CLLocationManager()
    private static var hasRequestedPermission = false

    /// Request location permission (needed for WiFi SSID on macOS)
    static func requestLocationPermission() {
        if !hasRequestedPermission {
            hasRequestedPermission = true
            locationManager.requestWhenInUseAuthorization()
        }
    }
    #endif

    /// Get the current WiFi network name (SSID)
    static func getCurrentSSID() -> String? {
        #if os(macOS)
        return getMacOSSSID()
        #elseif os(iOS) || os(watchOS)
        return getiOSWatchOSSSID()
        #else
        return nil
        #endif
    }

    #if os(macOS)
    private static func getMacOSSSID() -> String? {
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
            return nil
        }

        print("DEBUG: Successfully got SSID: \(ssid)")
        return ssid
    }
    #endif

    #if os(iOS) || os(watchOS)
    private static func getiOSWatchOSSSID() -> String? {
        // Use NEHotspotNetwork for iOS 14+ / watchOS 7+
        var ssid: String?
        let semaphore = DispatchSemaphore(value: 0)

        NEHotspotNetwork.fetchCurrent { network in
            ssid = network?.ssid
            semaphore.signal()
        }

        _ = semaphore.wait(timeout: .now() + 2.0)

        if let ssid = ssid {
            print("DEBUG: Successfully got SSID: \(ssid)")
        } else {
            print("DEBUG: Could not get SSID - may need location permission or WiFi info entitlement")
        }

        return ssid
    }
    #endif
}
