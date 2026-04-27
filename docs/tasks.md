# Tasks — Flutter V2Ray VPN MVP

## Phase 1 — Project Setup
- [x] T-01: Create Flutter project skeleton
- [x] T-02: Add dependencies to `pubspec.yaml` (flutter_v2ray, riverpod, http, etc.)
- [x] T-03: Configure `AndroidManifest.xml` (VPN permissions, intent-filter)
- [x] T-04: Configure iOS entitlements & Info.plist

## Phase 2 — Core / Data Layer
- [x] T-05: Implement `Failure` types and `AppException` classes
- [x] T-06: Implement `Base64DecoderService`
- [x] T-07: Implement `RemoteSubscriptionDataSource` (HTTP GET + decode)
- [x] T-08: Implement `ConfigParserService` (vmess/vless URI → `ServerConfigModel`)
- [x] T-09: Implement `ServerRepositoryImpl`

## Phase 3 — Domain Layer
- [x] T-10: Define `ServerConfig` entity
- [x] T-11: Define `VpnStatus` / `TrafficStats` entities
- [x] T-12: Define abstract `ServerRepository` & `VpnRepository`
- [x] T-13: Implement `FetchServersUseCase`
- [x] T-14: Implement `ConnectVpnUseCase` / `DisconnectVpnUseCase`
- [x] T-15: Implement `PingServerUseCase`

## Phase 4 — VPN Service
- [x] T-16: Implement `FlutterV2rayVpnRepository` wrapping `flutter_v2ray`
- [x] T-17: Wire status stream → `VpnStatus`
- [x] T-18: Wire traffic stream → `TrafficStats`
- [x] T-19: Implement Kill Switch logic

## Phase 5 — Presentation Layer
- [x] T-20: Setup Riverpod providers
- [x] T-21: Build `HomeScreen` (toggle button, duration, data usage)
- [x] T-22: Build `ServerListScreen` (searchable list, ping display)
- [x] T-23: Build `SpeedWidget` (real-time up/down speed)
- [x] T-24: Build shared widgets (status badge, server tile)

## Phase 6 — Polish & Error Handling
- [ ] T-25: Implement `OfflineView` and retry logic
- [ ] T-26: Add permission rationale dialog (Android)
- [ ] T-27: Add empty-state and error-state views
- [ ] T-28: Integration testing on Android emulator
- [ ] T-29: Integration testing on iOS simulator
