# Flutter V2Ray VPN

A production-ready Flutter VPN app using the V2Ray protocol (VMess/VLess) with dynamic server subscriptions fetched from GitHub.

## 🚀 Quick Start

**For detailed build instructions, see [BUILD.md](BUILD.md)**

```bash
git clone https://github.com/awaisable/flutter-v2ray-vpn.git
cd flutter-v2ray-vpn
flutter create --org com.example --project-name flutter_v2ray_vpn .
cp ci_android/AndroidManifest.xml android/app/src/main/AndroidManifest.xml
cp ci_android/gradle.properties android/gradle.properties
flutter pub get
flutter build apk --debug
```

APK output: `build/app/outputs/flutter-apk/app-debug.apk`

## Architecture

Clean Architecture with three layers:

```
lib/
├── core/          # Failures, exceptions, utilities
├── data/          # HTTP datasource, models, repository impls
├── domain/        # Entities, abstract repos, use cases
└── presentation/  # Riverpod providers, screens, widgets
```

## Android Setup

1. Ensure `minSdkVersion 21` in `android/app/build.gradle`
2. The `AndroidManifest.xml` already includes `BIND_VPN_SERVICE` and the VPN intent-filter
3. `gradle.properties` has `android.bundle.enableUncompressedNativeLibs=false` (required by flutter_v2ray)

## iOS Setup

1. Open `ios/Runner.xcworkspace` in Xcode
2. Add a new **Network Extension** target named `PacketTunnel`
3. Set the bundle ID to `com.example.flutter-v2ray-vpn.PacketTunnel`
4. Enable the **NetworkExtension** capability on both the Runner and PacketTunnel targets
5. Add the App Group `group.com.example.flutter-v2ray-vpn` to both targets
6. Replace the generated `PacketTunnelProvider.swift` with the one in `ios/PacketTunnel/`

> iOS VPN support in flutter_v2ray requires a paid license. See: https://t.me/blueboy_tm

## Features

- Dynamic subscription from `https://raw.githubusercontent.com/barry-far/V2ray-config/main/Sub1.txt`
- Base64 decoding of VMess / VLess / Trojan / Shadowsocks URIs
- Searchable server list with real-time ping
- Connect/Disconnect toggle with connection timer
- Real-time upload/download speed display
- Kill Switch (handled by flutter_v2ray's VPN mode)
- Robust error handling for offline/invalid config scenarios

## Dependencies

| Package | Purpose |
|---|---|
| `flutter_vless` | V2Ray/Xray native bridge (v2 embedding) |
| `flutter_riverpod` | State management |
| `http` | Subscription fetch |
| `flutter_animate` | UI animations |
