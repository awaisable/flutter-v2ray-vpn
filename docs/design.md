# Design — Flutter V2Ray VPN MVP

## 1. Architecture: Clean Architecture

```
lib/
├── core/
│   ├── error/          # Failure types & exceptions
│   └── utils/          # Base64 decoder, constants
├── data/
│   ├── datasources/    # Remote: HTTP subscription fetch
│   ├── models/         # ServerConfigModel (JSON ↔ domain)
│   └── repositories/   # Concrete implementations
├── domain/
│   ├── entities/       # ServerConfig, VpnStatus
│   ├── repositories/   # Abstract interfaces
│   └── usecases/       # FetchServers, ConnectVpn, DisconnectVpn, PingServer
└── presentation/
    ├── providers/      # Riverpod state notifiers
    └── screens/
        ├── home/       # Status page (connect/disconnect toggle)
        ├── servers/    # Server picker with search & ping
        └── widgets/    # Shared UI components
```

## 2. Data Flow

```
GitHub Raw URL
    │  HTTP GET
    ▼
RemoteSubscriptionDataSource
    │  Base64 decode → split lines
    ▼
ConfigParserService
    │  parse vmess:// / vless:// URIs
    ▼
List<ServerConfigModel>  →  List<ServerConfig> (domain entity)
    │
    ▼
ServerRepository (cached in memory)
    │
    ▼
Presentation (Riverpod providers)
```

## 3. VPN Service Layer

```
VpnRepository (abstract)
    └── FlutterV2rayVpnRepository (concrete)
            │  wraps flutter_v2ray
            ├── connect(ServerConfig)
            ├── disconnect()
            ├── statusStream → VpnStatus
            └── trafficStream → TrafficStats
```

## 4. State Management: Riverpod

| Provider | Type | Responsibility |
|---|---|---|
| `subscriptionProvider` | `AsyncNotifierProvider` | Fetch & cache server list |
| `selectedServerProvider` | `StateProvider` | Currently selected server |
| `vpnProvider` | `AsyncNotifierProvider` | VPN connect/disconnect/status |
| `trafficProvider` | `StreamProvider` | Real-time traffic stats |
| `pingProvider` | `FutureProvider.family` | Per-server ping |

## 5. Key Models

### ServerConfig (domain entity)
```dart
class ServerConfig {
  final String id;       // sha1 of raw URI
  final String remark;
  final String protocol; // vmess | vless
  final String address;
  final int port;
  final String rawUri;   // original URI for flutter_v2ray
}
```

### VpnStatus
```dart
enum VpnState { disconnected, connecting, connected, error }

class VpnStatus {
  final VpnState state;
  final Duration duration;
  final String? errorMessage;
}
```

### TrafficStats
```dart
class TrafficStats {
  final double uploadSpeed;   // bytes/s
  final double downloadSpeed; // bytes/s
  final int totalUpload;      // bytes
  final int totalDownload;    // bytes
}
```

## 6. Error Handling Strategy

| Scenario | Handling |
|---|---|
| No internet on launch | Show `OfflineView` with retry button |
| Subscription fetch fails (non-200) | Show error snackbar, use cached list if available |
| Base64 decode fails | Skip malformed lines, log warning |
| VPN permission denied | Show permission rationale dialog |
| VPN tunnel drops | Kill Switch activates, show reconnect prompt |
| Empty server list | Show empty state with refresh button |

## 7. Platform Configuration

### Android
- `AndroidManifest.xml`: `BIND_VPN_SERVICE`, `INTERNET`, `FOREGROUND_SERVICE`
- `android.bundle.enableUncompressedNativeLibs = false` in `gradle.properties`
- ABI splits: `armeabi-v7a`, `arm64-v8a`, `x86_64`

### iOS
- `NetworkExtension` entitlement
- `Packet Tunnel Provider` extension target
- `NSAppTransportSecurity` exception for raw GitHub URL
