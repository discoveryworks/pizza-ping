# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Pizza Ping is a network latency monitoring application with a playful pizza theme. It's designed as a continuous ping monitoring tool that uses public servers (like ICANN root servers) without requiring custom backend infrastructure.

## Core Concept

- Network speed/latency testing tool focused on ping times rather than bandwidth
- Passive, continuous monitoring with configurable intervals  
- Cross-platform support planned: web app, iOS native app, watchOS complications, macOS menu bar
- Pizza-themed UI and branding that builds on the existing Pizza Pong app's visual language

## Related Apps & Brand Context

This project is part of a "Pizza Pack" suite that includes Pizza Pong (a completed iOS pong game). Maintain consistency with Pizza Pong's design language:
- **Color Palette**: Neon green/pink accent colors, dark backgrounds with high contrast text
- **Pizza Visual Elements**: Pizza slice iconography, circular pizza-inspired progress indicators
- **Technical Stack**: Consider Swift/SpriteKit for iOS to match Pizza Pong's architecture

## Target Platforms & Features

- **iOS**: Widgets, Shortcuts integration, background processing
- **watchOS**: Complications, potential standalone app
- **macOS**: Menu bar integration
- **Web**: PWA capabilities for cross-platform reach

## Key Technical Constraints

- Must use public servers for ping testing (no custom backend)
- Handle high latency gracefully
- Lightweight and battery-efficient for mobile platforms
- Privacy-conscious network monitoring

## Development Status

**Current State**: Pre-development - concept and requirements phase only
- Only contains PROMPT.md with comprehensive PRD requirements
- No source code, build system, or package management files yet
- No established tech stack or development environment

## Next Steps for Implementation

When starting development, establish:
1. Platform-specific tech stack decisions
2. Public server endpoints for ping testing  
3. UI framework and component architecture
4. Cross-platform code sharing strategy
5. Build and deployment processes for target platforms

## Pizza Theming Guidelines

- Use pizza metaphors thoughtfully: "delivery time" for latency, "slice status" for connection quality
- Balance professional utility with playful branding
- Integrate pizza visual elements without making them gimmicky
- Consider gamification elements like delivery challenges and streak tracking