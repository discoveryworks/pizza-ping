//
//  Pizza_Ping_Complication.swift
//  Pizza Ping Complication
//
//  Created by Jonathan Berger on 11/20/25.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> PingEntry {
        PingEntry(date: Date(), status: .excellent, latency: 15)
    }

    func getSnapshot(in context: Context, completion: @escaping (PingEntry) -> ()) {
        let entry = PingEntry(date: Date(), status: .excellent, latency: 15)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        // Get current ping status from app group shared data
        let status = SharedPingData.currentStatus
        let latency = SharedPingData.currentLatency

        // Create entry for current status
        let entry = PingEntry(
            date: Date(),
            status: status,
            latency: latency
        )

        // Update every 5 minutes
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 5, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }
}

struct PingEntry: TimelineEntry {
    let date: Date
    let status: NetworkStatus
    let latency: TimeInterval?
}

struct Pizza_Ping_ComplicationEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        HStack(spacing: 2) {
            Text("🍕")
                .font(.system(size: 16))
            Text(statusEmoji)
                .font(.system(size: 16))
            if let latency = entry.latency {
                Text(String(format: "%.0fms", latency * 1000))
                    .font(.system(size: 12, design: .monospaced))
            }
        }
    }

    private var statusEmoji: String {
        switch entry.status {
        case .excellent, .good: return "🟢"
        case .slow: return "🟡"
        case .poor: return "🔴"
        case .disconnected: return "🚫"
        }
    }
}

struct Pizza_Ping_Complication: Widget {
    let kind: String = "Pizza_Ping_Complication"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(watchOS 10.0, *) {
                Pizza_Ping_ComplicationEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                Pizza_Ping_ComplicationEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Pizza Ping")
        .description("Network latency status")
        .supportedFamilies([.accessoryCircular, .accessoryRectangular, .accessoryInline])
    }
}

#Preview(as: .accessoryRectangular) {
    Pizza_Ping_Complication()
} timeline: {
    PingEntry(date: .now, status: .excellent, latency: 0.015)
    PingEntry(date: .now, status: .slow, latency: 0.180)
    PingEntry(date: .now, status: .poor, latency: 0.350)
}
