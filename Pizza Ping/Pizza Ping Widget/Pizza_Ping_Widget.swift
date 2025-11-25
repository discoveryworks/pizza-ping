//
//  Pizza_Ping_Widget.swift
//  Pizza Ping Widget
//
//  Created by Jonathan Berger on 11/24/25.
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
        // Get current ping status from shared data
        let status = SharedPingData.currentStatus
        let latency = SharedPingData.currentLatency

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

struct Pizza_Ping_WidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .accessoryCircular:
            // Lock Screen circular widget
            ZStack {
                AccessoryWidgetBackground()
                VStack(spacing: 2) {
                    Text(statusEmoji)
                        .font(.system(size: 24))
                    if let latency = entry.latency {
                        Text(String(format: "%.0f", latency * 1000))
                            .font(.system(size: 10, design: .monospaced))
                            .fontWeight(.bold)
                    }
                }
            }

        case .accessoryRectangular:
            // Lock Screen rectangular widget
            HStack(spacing: 4) {
                Text("🍕")
                    .font(.system(size: 20))
                Text(statusEmoji)
                    .font(.system(size: 20))
                if let latency = entry.latency {
                    Text(String(format: "%.0fms", latency * 1000))
                        .font(.system(size: 14, design: .monospaced))
                        .fontWeight(.semibold)
                }
            }

        case .accessoryInline:
            // Lock Screen inline widget
            HStack(spacing: 2) {
                Text("🍕")
                Text(statusEmoji)
                if let latency = entry.latency {
                    Text(String(format: "%.0fms", latency * 1000))
                        .font(.system(size: 12, design: .monospaced))
                }
            }

        default:
            // Home Screen widgets
            VStack(spacing: 8) {
                Text(statusEmoji)
                    .font(.system(size: 40))
                Text(entry.status.description)
                    .font(.headline)
                if let latency = entry.latency {
                    Text(String(format: "%.0f ms", latency * 1000))
                        .font(.system(.title3, design: .monospaced))
                        .foregroundStyle(.secondary)
                }
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

struct Pizza_Ping_Widget: Widget {
    let kind: String = "Pizza_Ping_Widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                Pizza_Ping_WidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                Pizza_Ping_WidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Pizza Ping")
        .description("Network latency status")
        .supportedFamilies([.systemSmall, .systemMedium, .accessoryCircular, .accessoryRectangular, .accessoryInline])
    }
}

#Preview(as: .accessoryCircular) {
    Pizza_Ping_Widget()
} timeline: {
    PingEntry(date: .now, status: .excellent, latency: 0.015)
    PingEntry(date: .now, status: .slow, latency: 0.120)
    PingEntry(date: .now, status: .poor, latency: 0.180)
}
