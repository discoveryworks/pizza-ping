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
            Text("🍕\(statusViewModel.statusEmoji)")
        }
        .menuBarExtraStyle(.window)
    }
}
