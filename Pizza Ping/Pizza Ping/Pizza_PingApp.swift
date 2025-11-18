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
        MenuBarExtra("Pizza Ping", systemImage: statusViewModel.menuBarIcon) {
            ContentView()
                .environmentObject(statusViewModel)
        }
        .menuBarExtraStyle(.window)
    }
}
