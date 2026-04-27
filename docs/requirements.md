# Requirements — Flutter V2Ray VPN MVP

## 1. Functional Requirements

### 1.1 Dynamic Subscription Service
- FR-01: On every app launch, fetch the raw subscription text from `https://raw.githubusercontent.com/barry-far/V2ray-config/main/Sub1.txt`
- FR-02: Decode the Base64-encoded response body into a newline-separated list of V2Ray URIs
- FR-03: Parse each `vmess://` or `vless://` URI into a structured `ServerConfig` model
- FR-04: Expose a manual "Refresh" action that re-fetches and re-parses the subscription
- FR-05: Handle HTTP errors (4xx/5xx), network timeouts, and empty/malformed payloads gracefully

### 1.2 VPN Connection
- FR-06: Allow the user to connect to a selected server via the `flutter_v2ray` package
- FR-07: Allow the user to disconnect from the active VPN tunnel
- FR-08: Display real-time connection duration (elapsed timer) while connected
- FR-09: Display real-time upload/download data usage while connected
- FR-10: Implement Kill Switch — drop all traffic if the VPN tunnel drops unexpectedly

### 1.3 Server Picker
- FR-11: Display all decoded servers in a scrollable, searchable list
- FR-12: Each list item shows the server's Remark (name) and measured ping (ms)
- FR-13: Tapping a server selects it as the active server for the next connection

### 1.4 Speed Test / Stats
- FR-14: Show real-time download and upload speed (KB/s or MB/s) via the package's stream listeners while connected

## 2. Non-Functional Requirements
- NFR-01: Clean Architecture — strict separation of Data, Domain, and Presentation layers
- NFR-02: Error states must be surfaced to the UI with actionable messages (no silent failures)
- NFR-03: The app must request VPN permission before starting the tunnel (Android)
- NFR-04: iOS NetworkExtension entitlements and Packet Tunnel Provider target must be configured
- NFR-05: Android `BIND_VPN_SERVICE` permission and intent-filter must be declared in the manifest
- NFR-06: Minimum Android SDK: 21 | Minimum iOS: 14.0

## 3. Out of Scope (MVP)
- User authentication / account management
- Custom subscription URL input
- Traffic routing rules editor
- Desktop platform support
