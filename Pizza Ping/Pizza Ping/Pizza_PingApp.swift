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

    init() {
        print("DEBUG: Pizza_PingApp init")
    }

    var body: some Scene {
        print("DEBUG: Creating MenuBarExtra with image: \(statusImage)")
        return
        MenuBarExtra {
            ContentView()
                .environmentObject(statusViewModel)
        } label: {
            if let nsImage = NSImage(named: statusImage) {
                let coloredImage = nsImage
                coloredImage.isTemplate = false
                return AnyView(Image(nsImage: coloredImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18))
            } else {
                return AnyView(Text("🍕\(statusViewModel.statusEmoji)"))
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
