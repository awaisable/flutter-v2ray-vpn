# Flutter V2Ray VPN MVP - Design Document

## 1. Architecture Overview

### 1.1 Clean Architecture Layers

```
┌─────────────────────────────────────────┐
│         Presentation Layer              │
│  (UI, ViewModels, State Management)     │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│          Domain Layer                   │
│  (Use Cases, Entities, Repositories)    │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│           Data Layer                    │
│  (Data Sources, Models, Parsers)        │
└─────────────────────────────────────────┘
```

## 2. Project Structure

```
lib/
├── core/
│   ├── constants/
│   │   └── app_constants.dart
│   ├── errors/
│   │   └── failures.dart
│   ├── utils/
│   │   ├── base64_decoder.dart
│   │   └── uri_parser.dart
│   └── network/
│       └── network_info.dart
├── data/
│   ├── models/
│   │   ├── server_config_model.dart
│   │   └── connection_stats_model.dart
│   ├── datasources/
│   │   ├── remote/
│   │   │   └── subscription_remote_datasource.dart
│   │   └── local/
│   │       └── server_cache_datasource.dart
│   └── repositories/
│       ├── subscription_repository_impl.dart
│       └── vpn_repository_impl.dart
├── domain/
│   ├── entities/
│   │   ├── server_config.dart
│   │   └── connection_stats.dart
│   ├── repositories/
│   │   ├── subscription_repository.dart
│   │   └── vpn_repository.dart
│   └── usecases/
│       ├── fetch_servers.dart
│       ├── connect_vpn.dart
│       ├── disconnect_vpn.dart
│       ├── get_connection_stats.dart
│       └── ping_server.dart
├── presentation/
│   ├── providers/
│   │   ├── vpn_provider.dart
│   │   └── server_provider.dart
│   ├── screens/
│   │   ├── home_screen.dart
│   │   └── server_list_screen.dart
│   └── widgets/
│       ├── connection_button.dart
│       ├── stats_display.dart
│       ├── speed_chart.dart
│       └── server_list_item.dart
└── main.dart
```

## 3. Data Models

### 3.1 Server Configuration Entity

```dart
class ServerConfig {
  final String id;
  final String remark;
  final String address;
  final int port;
  final String protocol; // vmess or vless
  final String userId;
  final String alterId;
  final String security;
  final String network;
  final Map<String, dynamic> streamSettings;
  int? latency;
}
```

### 3.2 Connection Statistics Entity

```dart
class ConnectionStats {
  final Duration duration;
  final int uploadBytes;
  final int downloadBytes;
  final double uploadSpeed; // bytes per second
  final double downloadSpeed; // bytes per second
  final ConnectionStatus status;
}

enum ConnectionStatus {
  disconnected,
  connecting,
  connected,
  disconnecting,
  error
}
```

## 4. Component Design

### 4.1 Subscription Service

**Responsibility**: Fetch and parse server configurations from remote source

**Key Methods**:
- `Future<List<ServerConfig>> fetchServers()`
- `List<String> decodeBase64Subscription(String base64Data)`
- `ServerConfig parseVMessUri(String uri)`
- `ServerConfig parseVLessUri(String uri)`

**Flow**:
1. HTTP GET to subscription URL
2. Decode Base64 response
3. Split by newlines to get individual URIs
4. Parse each URI into ServerConfig
5. Filter out invalid configurations
6. Return list of valid ServerConfig objects

### 4.2 VPN Service

**Responsibility**: Manage V2Ray connection lifecycle

**Key Methods**:
- `Future<void> connect(ServerConfig config)`
- `Future<void> disconnect()`
- `Stream<ConnectionStats> getStatsStream()`
- `Future<ConnectionStatus> getStatus()`

**Integration**: Uses flutter_v2ray package methods:
- `V2RayFlutter.startV2Ray()`
- `V2RayFlutter.stopV2Ray()`
- `V2RayFlutter.getConnectedServerDelay()`
- `V2RayFlutter.getServerDelay()`

### 4.3 Config Parser

**Responsibility**: Parse VMess/VLess URI strings

**VMess URI Format**:
```
vmess://[Base64 encoded JSON]
```

**VMess JSON Structure**:
```json
{
  "v": "2",
  "ps": "remark",
  "add": "address",
  "port": "port",
  "id": "uuid",
  "aid": "alterId",
  "net": "network",
  "type": "headerType",
  "host": "host",
  "path": "path",
  "tls": "tls"
}
```

**VLess URI Format**:
```
vless://[UUID]@[address]:[port]?[parameters]#[remark]
```

### 4.4 Ping Service

**Responsibility**: Test server latency

**Implementation**:
- Use flutter_v2ray's `getServerDelay()` method
- Timeout after 5 seconds
- Return latency in milliseconds or null if unreachable

## 5. State Management

### 5.1 VPN Provider

**State**:
- Current connection status
- Selected server
- Connection statistics
- Error messages

**Actions**:
- `connectToServer(ServerConfig server)`
- `disconnect()`
- `selectServer(ServerConfig server)`

### 5.2 Server Provider

**State**:
- List of available servers
- Loading state
- Search query
- Filtered server list

**Actions**:
- `refreshServers()`
- `searchServers(String query)`
- `pingServer(ServerConfig server)`
- `pingAllServers()`

## 6. UI Design

### 6.1 Home Screen Layout

```
┌─────────────────────────────────────┐
│  [App Bar: V2Ray VPN]               │
├─────────────────────────────────────┤
│                                     │
│     [Connection Status Icon]        │
│          Connected                  │
│                                     │
│   ┌───────────────────────────┐    │
│   │   [Connect/Disconnect]    │    │
│   │      Toggle Button        │    │
│   └───────────────────────────┘    │
│                                     │
│   Server: Server Name               │
│   Duration: 00:15:32                │
│                                     │
│   ↑ Upload: 125 MB (1.2 MB/s)      │
│   ↓ Download: 450 MB (3.5 MB/s)    │
│                                     │
│   [Speed Chart]                     │
│                                     │
│   ┌───────────────────────────┐    │
│   │   [Change Server]         │    │
│   └───────────────────────────┘    │
│                                     │
└─────────────────────────────────────┘
```

### 6.2 Server List Screen Layout

```
┌─────────────────────────────────────┐
│  [← Back] Select Server  [Refresh]  │
├─────────────────────────────────────┤
│  [Search: 🔍 ____________]          │
├─────────────────────────────────────┤
│  ┌─────────────────────────────┐   │
│  │ ● Server Name 1             │   │
│  │   vmess://example.com       │   │
│  │   Ping: 45ms          [✓]   │   │
│  └─────────────────────────────┘   │
│  ┌─────────────────────────────┐   │
│  │ ○ Server Name 2             │   │
│  │   vless://example2.com      │   │
│  │   Ping: 120ms               │   │
│  └─────────────────────────────┘   │
│  ┌─────────────────────────────┐   │
│  │ ○ Server Name 3             │   │
│  │   vmess://example3.com      │   │
│  │   Ping: Testing...          │   │
│  └─────────────────────────────┘   │
│                                     │
└─────────────────────────────────────┘
```

## 7. Platform-Specific Configuration

### 7.1 Android (AndroidManifest.xml)

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<uses-permission android:name="android.permission.BIND_VPN_SERVICE" />
<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />

<service
    android:name="com.github.blueboytm.flutter_v2ray.V2RayVPNService"
    android:permission="android.permission.BIND_VPN_SERVICE"
    android:exported="true">
    <intent-filter>
        <action android:name="android.net.VpnService" />
    </intent-filter>
</service>
```

### 7.2 iOS (Info.plist & Entitlements)

**Entitlements**:
```xml
<key>com.apple.developer.networking.networkextension</key>
<array>
    <string>packet-tunnel-provider</string>
</array>
```

**Info.plist**:
```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

## 8. Error Handling Strategy

### 8.1 Network Errors
- **No Internet**: Display "No internet connection" with retry button
- **Timeout**: Display "Request timed out" with retry option
- **Server Unreachable**: Display "Cannot reach subscription server"

### 8.2 Configuration Errors
- **Invalid Base64**: Log error, skip invalid entries
- **Malformed URI**: Log error, skip invalid entries
- **Empty Subscription**: Display "No servers available"

### 8.3 VPN Errors
- **Permission Denied**: Prompt user to grant VPN permission
- **Connection Failed**: Display specific error from V2Ray core
- **Disconnection**: Auto-reconnect with exponential backoff

## 9. Security Considerations

### 9.1 Kill Switch Implementation
- Monitor VPN connection state
- On unexpected disconnect, block all network traffic
- Restore traffic only when VPN reconnects or user disables kill switch

### 9.2 Data Protection
- No logging of user traffic
- Server configurations cached locally (encrypted if possible)
- Clear sensitive data on app uninstall

## 10. Performance Optimization

### 10.1 Caching Strategy
- Cache server list locally
- Refresh on app launch (background)
- Manual refresh option
- Cache expiry: 24 hours

### 10.2 Lazy Loading
- Load server list progressively
- Ping servers on-demand or in background
- Prioritize UI responsiveness

### 10.3 Resource Management
- Dispose streams properly
- Cancel pending requests on screen exit
- Efficient state updates (only when changed)
