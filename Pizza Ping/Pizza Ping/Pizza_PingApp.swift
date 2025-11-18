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

    var body: some Scene {
        MenuBarExtra {
            ContentView()
                .environmentObject(statusViewModel)
        } label: {
            HStack(spacing: 2) {
                Text("🍕")
                Circle()
                    .fill(statusViewModel.statusColor)
                    .frame(width: 8, height: 8)
            }
        }
        .menuBarExtraStyle(.window)
    }
}
