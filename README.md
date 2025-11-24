# Pizza Ping

Network latency monitor. (But with more pizza.)

A clean, ad-free network monitoring tool that lives in your menu bar (macOS), on your wrist (Apple Watch), and in your pocket (iOS). Shows current latency with a pizza emoji and colored status indicator.

## Installation

### Homebrew (Recommended)
```bash
brew tap discoveryworks/pizzalabs
brew install --cask pizza-ping
```

### Direct Download
[Download Pizza Ping v1.0.0](https://github.com/discoveryworks/pizza-ping/releases/latest)

Unzip and drag to Applications folder.

## Features

- **Menu bar status** (macOS) with WiFi network name
- **Apple Watch app** with complication support
- **iOS companion app**
- Automatic pings every 5 minutes
- Rotating DNS servers (Google, Cloudflare, Quad9)
- CSV history logging (macOS)
- Long-press to ping on watchOS

## Status Indicators

Pizza Ping uses industry-standard latency thresholds:

| Status | Latency | Indicator | Use Cases |
|--------|---------|-----------|-----------|
| Excellent | < 50ms | 🍕🟢 | Perfect for gaming, video calls, real-time apps |
| Good | 50-100ms | 🍕🟢 | Good for most uses, acceptable for gaming |
| Slow | 100-150ms | 🍕🟡 | Noticeable lag, video calls may suffer |
| Poor | > 150ms | 🍕🔴 | Significant delays, poor user experience |
| Disconnected | Failed | 🍕🚫 | No network connection |

**Based on industry standards:**
- VoIP/Video conferencing works best under 50ms
- Gaming requires under 100ms for competitive play
- General web browsing acceptable up to 150ms
- Over 150ms creates noticeable lag

## Requirements

- **macOS:** 15.1+ (menu bar app)
- **iOS:** 18.1+ (companion app)
- **watchOS:** 11.0+ (watch app with complications)
- **Location Services:** Required for WiFi network name display

## Privacy

Pizza Ping:
- Does not collect or transmit any data
- Stores ping history locally only (macOS)
- Only accesses location to display WiFi network name
- No analytics, no tracking, no ads

See full [Privacy Policy](https://discovery.works/privacy/)

## Development

Built with Swift/SwiftUI. Free and open source.

### Two Build Variants

- **Pizza Ping:** Full-featured (Homebrew distribution)
- **Pizza Ping Lite:** App Store version (sandboxed)

### Tech Stack

- Swift/SwiftUI for all platforms
- Network.framework for TCP latency testing
- CoreWLAN (macOS) / NetworkExtension (iOS/watchOS) for WiFi info
- WidgetKit for watchOS complications
- CloudKit-free, server-free architecture

## Links

- Website: https://discovery.works/labs/pizza/
- Repository: https://github.com/discoveryworks/pizza-ping
- Issues: https://github.com/discoveryworks/pizza-ping/issues

---

Part of the [Pizza Labs](https://discovery.works/labs/pizza/) suite.
