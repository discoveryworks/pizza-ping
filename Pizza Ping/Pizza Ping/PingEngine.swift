//
//  PingEngine.swift
//  Pizza Ping
//
//  Created by Claude on 11/18/25.
//

import Foundation
import Network

/// Handles network latency monitoring via TCP connections
class PingEngine {

    /// Performs a simple TCP connection test to measure latency
    /// - Parameters:
    ///   - host: The hostname or IP address to ping
    ///   - port: The port to connect to (default: 53 for DNS)
    ///   - timeout: Maximum time to wait for response
    /// - Returns: Latency in seconds, or nil if failed
    static func ping(host: String, port: UInt16 = 53, timeout: TimeInterval = 5.0) async -> TimeInterval? {
        return await withCheckedContinuation { continuation in
            let start = Date()

            // Create NWConnection for TCP test
            let connection = NWConnection(
                host: NWEndpoint.Host(host),
                port: NWEndpoint.Port(integerLiteral: port),
                using: .tcp
            )

            // Use NSLock for thread-safe access
            let lock = NSLock()
            var hasReturned = false

            // Set up timeout
            DispatchQueue.global().asyncAfter(deadline: .now() + timeout) {
                lock.lock()
                let shouldReturn = !hasReturned
                if shouldReturn {
                    hasReturned = true
                }
                lock.unlock()

                if shouldReturn {
                    connection.cancel()
                    continuation.resume(returning: nil)
                }
            }

            connection.stateUpdateHandler = { state in
                switch state {
                case .ready:
                    lock.lock()
                    let shouldReturn = !hasReturned
                    if shouldReturn {
                        hasReturned = true
                    }
                    lock.unlock()

                    if shouldReturn {
                        let latency = Date().timeIntervalSince(start)
                        connection.cancel()
                        continuation.resume(returning: latency)
                    }
                case .failed:
                    lock.lock()
                    let shouldReturn = !hasReturned
                    if shouldReturn {
                        hasReturned = true
                    }
                    lock.unlock()

                    if shouldReturn {
                        connection.cancel()
                        continuation.resume(returning: nil)
                    }
                default:
                    break
                }
            }

            connection.start(queue: .global())
        }
    }

    /// Pings a single target and returns the result
    /// - Parameter target: Target to ping
    /// - Returns: Ping result with network name
    static func pingSingleTarget(_ target: PingTarget) async -> PingResult {
        let latency = await ping(host: target.rawValue)
        let networkName = NetworkInfo.getCurrentSSID()
        return PingResult(target: target.rawValue, latency: latency, networkName: networkName)
    }

    /// Pings multiple targets and returns the best result
    /// - Parameter targets: Array of targets to ping
    /// - Returns: The fastest successful ping result, or failed result if all fail
    static func pingMultipleTargets(_ targets: [PingTarget]) async -> PingResult {
        // Ping all targets in parallel
        let results = await withTaskGroup(of: (PingTarget, TimeInterval?).self) { group in
            for target in targets {
                group.addTask {
                    let latency = await ping(host: target.rawValue)
                    return (target, latency)
                }
            }

            var allResults: [(PingTarget, TimeInterval?)] = []
            for await result in group {
                allResults.append(result)
            }
            return allResults
        }

        // Find the fastest successful ping
        let successful = results.compactMap { target, latency -> (String, TimeInterval)? in
            guard let latency = latency else { return nil }
            return (target.rawValue, latency)
        }

        // Get current network name
        let networkName = NetworkInfo.getCurrentSSID()

        if let fastest = successful.min(by: { $0.1 < $1.1 }) {
            return PingResult(target: fastest.0, latency: fastest.1, networkName: networkName)
        } else {
            // All pings failed
            return PingResult(target: targets.first?.rawValue ?? "unknown", latency: nil, networkName: networkName)
        }
    }
}
