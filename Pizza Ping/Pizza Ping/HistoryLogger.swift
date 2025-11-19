//
//  HistoryLogger.swift
//  Pizza Ping
//
//  Created by Claude on 11/18/25.
//

import Foundation
import AppKit

/// Manages logging of ping history to CSV file
class HistoryLogger {
    static let shared = HistoryLogger()

    private let fileManager = FileManager.default
    private let historyFileName = "history.csv"

    private init() {
        ensureHistoryFileExists()
    }

    /// Application Support directory for Pizza Ping
    private var appSupportDirectory: URL? {
        guard let appSupport = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
            return nil
        }
        let pizzaPingDir = appSupport.appendingPathComponent("Pizza Ping")

        // Create directory if it doesn't exist
        if !fileManager.fileExists(atPath: pizzaPingDir.path) {
            try? fileManager.createDirectory(at: pizzaPingDir, withIntermediateDirectories: true)
        }

        return pizzaPingDir
    }

    /// Path to history CSV file
    private var historyFileURL: URL? {
        appSupportDirectory?.appendingPathComponent(historyFileName)
    }

    /// Ensure history file exists with CSV header
    private func ensureHistoryFileExists() {
        guard let fileURL = historyFileURL else { return }

        if !fileManager.fileExists(atPath: fileURL.path) {
            let header = "timestamp,server,latency_ms,status\n"
            try? header.write(to: fileURL, atomically: true, encoding: .utf8)
        }
    }

    /// Log a ping result to the history file
    func log(_ result: PingResult) {
        guard let fileURL = historyFileURL else { return }

        let status = NetworkStatus(latency: result.latency)
        let latencyMs = result.latency != nil ? String(format: "%.0f", result.latency! * 1000) : "failed"
        let timestamp = ISO8601DateFormatter().string(from: result.timestamp)

        let line = "\(timestamp),\(result.target),\(latencyMs),\(status.description)\n"

        // Append to file
        if let fileHandle = try? FileHandle(forWritingTo: fileURL) {
            fileHandle.seekToEndOfFile()
            if let data = line.data(using: .utf8) {
                fileHandle.write(data)
            }
            try? fileHandle.close()
        }
    }

    /// Open history file in default text editor
    func openHistoryFile() {
        guard let fileURL = historyFileURL else { return }

        if fileManager.fileExists(atPath: fileURL.path) {
            NSWorkspace.shared.open(fileURL)
        }
    }
}
