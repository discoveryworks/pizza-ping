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
            Image(statusImage)
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frame(width: 18, height: 18)
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
