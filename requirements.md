# Flutter V2Ray VPN MVP - Requirements Document

## 1. Project Overview
A production-ready Flutter VPN application utilizing V2Ray protocol (VMess/VLess) with dynamic server configuration fetching from a remote GitHub repository.

## 2. Functional Requirements

### 2.1 Dynamic Configuration Service
- **FR-1.1**: Fetch server configurations via HTTP GET from `https://raw.githubusercontent.com/barry-far/V2ray-config/main/Sub1.txt`
- **FR-1.2**: Decode Base64-encoded response body into vmess:// or vless:// URI strings
- **FR-1.3**: Parse URI strings into structured server configuration objects
- **FR-1.4**: Refresh server list automatically on app launch
- **FR-1.5**: Manual refresh capability via UI action

### 2.2 VPN Connection Management
- **FR-2.1**: Connect to selected V2Ray server using VMess/VLess protocol
- **FR-2.2**: Disconnect from active VPN connection
- **FR-2.3**: Display real-time connection status (Connected/Disconnected/Connecting)
- **FR-2.4**: Track and display connection duration
- **FR-2.5**: Track and display data usage (upload/download)
- **FR-2.6**: Implement kill switch to prevent data leaks on disconnect

### 2.3 Server Management
- **FR-3.1**: Display list of all available servers with metadata
- **FR-3.2**: Show server remark/name for each server
- **FR-3.3**: Display ping/latency for each server
- **FR-3.4**: Search/filter servers by name
- **FR-3.5**: Test server latency on demand

### 2.4 Performance Monitoring
- **FR-4.1**: Real-time download speed visualization
- **FR-4.2**: Real-time upload speed visualization
- **FR-4.3**: Historical speed data display

## 3. Non-Functional Requirements

### 3.1 Performance
- **NFR-1.1**: Server list refresh should complete within 5 seconds
- **NFR-1.2**: VPN connection establishment within 10 seconds
- **NFR-1.3**: UI should remain responsive during all operations

### 3.2 Security
- **NFR-2.1**: All server configurations transmitted over HTTPS
- **NFR-2.2**: No logging of user traffic or browsing data
- **NFR-2.3**: Kill switch prevents unencrypted traffic leaks
- **NFR-2.4**: Secure storage of user preferences

### 3.3 Reliability
- **NFR-3.1**: Graceful handling of network errors
- **NFR-3.2**: Automatic reconnection on connection drop
- **NFR-3.3**: Robust error handling for invalid configurations

### 3.4 Compatibility
- **NFR-4.1**: Support Android 5.0 (API 21) and above
- **NFR-4.2**: Support iOS 12.0 and above
- **NFR-4.3**: Support both VMess and VLess protocols

## 4. Technical Requirements

### 4.1 Dependencies
- **TR-1.1**: Flutter SDK (latest stable)
- **TR-1.2**: flutter_v2ray package (latest stable 2026 version)
- **TR-1.3**: HTTP client for API requests
- **TR-1.4**: Base64 decoder
- **TR-1.5**: State management solution (Provider/Riverpod/Bloc)

### 4.2 Android Configuration
- **TR-2.1**: BIND_VPN_SERVICE permission in AndroidManifest.xml
- **TR-2.2**: VPN service intent-filter configuration
- **TR-2.3**: Foreground service support

### 4.3 iOS Configuration
- **TR-3.1**: NetworkExtension framework entitlements
- **TR-3.2**: Packet Tunnel Provider target
- **TR-3.3**: VPN configuration capabilities

## 5. Error Handling Requirements

### 5.1 Network Errors
- **EH-1.1**: Display user-friendly message for no internet connection
- **EH-1.2**: Retry mechanism for failed configuration fetches
- **EH-1.3**: Offline mode with cached server list

### 5.2 Configuration Errors
- **EH-2.1**: Validate server configurations before use
- **EH-2.2**: Skip invalid configurations with logging
- **EH-2.3**: Display error message for completely invalid subscription

### 5.3 Connection Errors
- **EH-3.1**: Handle VPN permission denial gracefully
- **EH-3.2**: Display specific error messages for connection failures
- **EH-3.3**: Automatic fallback to alternative server on failure

## 6. User Interface Requirements

### 6.1 Status Page
- **UI-1.1**: Large, prominent Connect/Disconnect toggle button
- **UI-1.2**: Connection status indicator (color-coded)
- **UI-1.3**: Connection duration timer
- **UI-1.4**: Data usage display (upload/download)
- **UI-1.5**: Current server name display
- **UI-1.6**: Real-time speed graph

### 6.2 Server Picker
- **UI-2.1**: Scrollable list of all servers
- **UI-2.2**: Search bar for filtering servers
- **UI-2.3**: Server name/remark display
- **UI-2.4**: Latency/ping display per server
- **UI-2.5**: Visual indicator for selected server
- **UI-2.6**: Refresh button for server list

### 6.3 General UI
- **UI-3.1**: Material Design 3 compliance
- **UI-3.2**: Dark/Light theme support
- **UI-3.3**: Responsive layout for various screen sizes
- **UI-3.4**: Loading indicators for async operations

## 7. Architecture Requirements

### 7.1 Clean Architecture
- **AR-1.1**: Separation of concerns (Data/Domain/Presentation layers)
- **AR-1.2**: VPN Service abstraction layer
- **AR-1.3**: Config Parser as independent module
- **AR-1.4**: UI Views decoupled from business logic

### 7.2 Code Quality
- **AR-2.1**: Comprehensive error handling
- **AR-2.2**: Logging for debugging
- **AR-2.3**: Code documentation
- **AR-2.4**: Unit tests for critical components

## 8. Out of Scope (MVP)
- User authentication/accounts
- Custom server addition
- Protocol switching (Shadowsocks, Trojan, etc.)
- Advanced routing rules
- Multi-language support
- Server favorites/bookmarks
