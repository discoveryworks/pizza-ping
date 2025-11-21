//
//  Pizza_PingApp.swift
//  Pizza Ping
//
//  Created by Jonathan Berger on 11/18/25.
//

import SwiftUI

@main
struct Pizza_PingApp: App {
    @StateObject private var statusViewModel = StatusViewModel()

    // Toggle between dot and pepperoni styles
    private let usePepperoniStyle = false

    var body: some Scene {
        MenuBarExtra {
            ContentView()
                .environmentObject(statusViewModel)
        } label: {
            if let nsImage = NSImage(named: statusImage) {
                Image(nsImage: nsImage)
            } else {
                // Fallback to emoji if image not found
                Text("🍕\(statusViewModel.statusEmoji)")
            }
        }
        .menuBarExtraStyle(.window)
    }

    private var statusImage: String {
        switch statusViewModel.currentStatus {
        case .excellent, .good: return "PizzaGreen"
        case .slow: return "PizzaAmber"
        case .poor: return "PizzaRed"
        case .disconnected: return "PizzaNo"
        }
    }
}
