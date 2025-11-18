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
            if usePepperoniStyle {
                // Pepperoni style: overlaid colored circles on pizza
                ZStack(alignment: .topTrailing) {
                    Text("🍕")
                        .font(.system(size: 16))
                    Circle()
                        .fill(statusViewModel.statusColor)
                        .frame(width: 6, height: 6)
                        .offset(x: -2, y: 2)
                }
            } else {
                // Dot style: pizza + separate status dot
                HStack(spacing: 3) {
                    Text("🍕")
                        .font(.system(size: 16))
                    Circle()
                        .fill(statusViewModel.statusColor)
                        .frame(width: 10, height: 10)
                        .overlay(
                            Circle()
                                .strokeBorder(.white.opacity(0.3), lineWidth: 1)
                        )
                }
            }
        }
        .menuBarExtraStyle(.window)
    }
}
