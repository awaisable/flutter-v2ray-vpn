# Flutter V2Ray VPN MVP - Implementation Tasks

## Phase 1: Project Setup & Foundation

### Task 1.1: Initialize Flutter Project
- [ ] Create new Flutter project with appropriate bundle ID
- [ ] Configure minimum SDK versions (Android 21+, iOS 12+)
- [ ] Setup project structure following Clean Architecture
- [ ] Create folder structure as per design document

### Task 1.2: Add Dependencies
- [ ] Add flutter_v2ray package to pubspec.yaml
- [ ] Add http package for API requests
- [ ] Add provider/riverpod for state management
- [ ] Add fl_chart for speed visualization
- [ ] Add shared_preferences for local caching
- [ ] Add connectivity_plus for network status
- [ ] Run flutter pub get

### Task 1.3: Platform Configuration - Android
- [ ] Update AndroidManifest.xml with VPN permissions
- [ ] Add BIND_VPN_SERVICE permission
- [ ] Add INTERNET and ACCESS_NETWORK_STATE permissions
- [ ] Configure VPN service intent-filter
- [ ] Add FOREGROUND_SERVICE permission
- [ ] Set minSdkVersion to 21

### Task 1.4: Platform Configuration - iOS
- [ ] Create Packet Tunnel Provider target
- [ ] Add NetworkExtension entitlements
- [ ] Configure Info.plist for VPN capabilities
- [ ] Setup App Groups for data sharing
- [ ] Configure NSAppTransportSecurity

## Phase 2: Core Data Layer

### Task 2.1: Create Core Utilities
- [ ] Implement Base64 decoder utility (core/utils/base64_decoder.dart)
- [ ] Create URI parser utility (core/utils/uri_parser.dart)
- [ ] Define app constants (core/constants/app_constants.dart)
- [ ] Create failure classes (core/errors/failures.dart)
- [ ] Implement network info checker (core/network/network_info.dart)

### Task 2.2: Define Data Models
- [ ] Create ServerConfigModel (data/models/server_config_model.dart)
- [ ] Add fromVMessUri factory constructor
- [ ] Add fromVLessUri factory constructor
- [ ] Add toJson/fromJson methods
- [ ] Create ConnectionStatsModel (data/models/connection_stats_model.dart)
- [ ] Add serialization methods

### Task 2.3: Implement Remote Data Source
- [ ] Create SubscriptionRemoteDataSource (data/datasources/remote/)
- [ ] Implement fetchSubscriptionData() method
- [ ] Add HTTP GET request to GitHub URL
- [ ] Implement Base64 decoding logic
- [ ] Add error handling for network failures
- [ ] Add timeout configuration (10 seconds)

### Task 2.4: Implement Config Parser
- [ ] Create ConfigParser service
- [ ] Implement parseVMessUri() method
- [ ] Parse Base64-encoded VMess JSON
- [ ] Extract all VMess parameters
- [ ] Implement parseVLessUri() method
- [ ] Parse VLess URI query parameters
- [ ] Add validation for required fields
- [ ] Handle malformed URIs gracefully

### Task 2.5: Implement Local Cache
- [ ] Create ServerCacheDataSource (data/datasources/local/)
- [ ] Implement cacheServers() method
- [ ] Implement getCachedServers() method
- [ ] Add cache timestamp tracking
- [ ] Implement cache expiry logic (24 hours)

## Phase 3: Domain Layer

### Task 3.1: Define Domain Entities
- [ ] Create ServerConfig entity (domain/entities/server_config.dart)
- [ ] Define all required properties
- [ ] Create ConnectionStats entity (domain/entities/connection_stats.dart)
- [ ] Define ConnectionStatus enum

### Task 3.2: Define Repository Interfaces
- [ ] Create SubscriptionRepository interface (domain/repositories/)
- [ ] Define fetchServers() method signature
- [ ] Create VpnRepository interface
- [ ] Define connect(), disconnect(), getStats() signatures

### Task 3.3: Implement Use Cases
- [ ] Create FetchServers use case (domain/usecases/fetch_servers.dart)
- [ ] Create ConnectVpn use case (domain/usecases/connect_vpn.dart)
- [ ] Create DisconnectVpn use case (domain/usecases/disconnect_vpn.dart)
- [ ] Create GetConnectionStats use case (domain/usecases/get_connection_stats.dart)
- [ ] Create PingServer use case (domain/usecases/ping_server.dart)

## Phase 4: Repository Implementation

### Task 4.1: Implement Subscription Repository
- [ ] Create SubscriptionRepositoryImpl (data/repositories/)
- [ ] Inject remote and local data sources
- [ ] Implement fetchServers() with caching logic
- [ ] Add network connectivity check
- [ ] Return cached data when offline
- [ ] Handle all error scenarios

### Task 4.2: Implement VPN Repository
- [ ] Create VpnRepositoryImpl (data/repositories/)
- [ ] Integrate flutter_v2ray package
- [ ] Implement connect() method
- [ ] Convert ServerConfig to V2Ray config format
- [ ] Call V2RayFlutter.startV2Ray()
- [ ] Implement disconnect() method
- [ ] Implement getStats() stream
- [ ] Parse V2Ray statistics
- [ ] Implement getStatus() method

### Task 4.3: Implement Ping Service
- [ ] Create PingService
- [ ] Use V2RayFlutter.getServerDelay()
- [ ] Add timeout handling (5 seconds)
- [ ] Return latency in milliseconds
- [ ] Handle unreachable servers

## Phase 5: Presentation Layer - State Management

### Task 5.1: Create VPN Provider
- [ ] Create VpnProvider (presentation/providers/vpn_provider.dart)
- [ ] Define state properties (status, stats, selectedServer)
- [ ] Implement connectToServer() method
- [ ] Implement disconnect() method
- [ ] Implement selectServer() method
- [ ] Add error state management
- [ ] Setup stats stream listener
- [ ] Implement auto-reconnect logic

### Task 5.2: Create Server Provider
- [ ] Create ServerProvider (presentation/providers/server_provider.dart)
- [ ] Define state properties (servers, loading, searchQuery)
- [ ] Implement refreshServers() method
- [ ] Implement searchServers() method
- [ ] Implement pingServer() method
- [ ] Implement pingAllServers() method
- [ ] Add loading state management

## Phase 6: UI Implementation

### Task 6.1: Create Reusable Widgets
- [ ] Create ConnectionButton widget (presentation/widgets/connection_button.dart)
- [ ] Add large toggle button with animations
- [ ] Show loading state during connection
- [ ] Create StatsDisplay widget (presentation/widgets/stats_display.dart)
- [ ] Display duration, upload, download
- [ ] Format bytes to human-readable format
- [ ] Create SpeedChart widget (presentation/widgets/speed_chart.dart)
- [ ] Integrate fl_chart for real-time graph
- [ ] Show upload/download speed lines
- [ ] Create ServerListItem widget (presentation/widgets/server_list_item.dart)
- [ ] Display server name, address, ping
- [ ] Add selection indicator
- [ ] Add ping button

### Task 6.2: Implement Home Screen
- [ ] Create HomeScreen (presentation/screens/home_screen.dart)
- [ ] Add app bar with title
- [ ] Add connection status indicator
- [ ] Integrate ConnectionButton widget
- [ ] Display selected server name
- [ ] Integrate StatsDisplay widget
- [ ] Integrate SpeedChart widget
- [ ] Add "Change Server" button
- [ ] Connect to VpnProvider
- [ ] Handle VPN permission requests

### Task 6.3: Implement Server List Screen
- [ ] Create ServerListScreen (presentation/screens/server_list_screen.dart)
- [ ] Add app bar with back button and refresh
- [ ] Add search bar with filtering
- [ ] Implement scrollable server list
- [ ] Integrate ServerListItem widgets
- [ ] Connect to ServerProvider
- [ ] Handle server selection
- [ ] Navigate back on selection
- [ ] Add pull-to-refresh functionality
- [ ] Show loading indicator during refresh

### Task 6.4: Setup Navigation
- [ ] Configure routes in main.dart
- [ ] Setup navigation between screens
- [ ] Add screen transitions

## Phase 7: Advanced Features

### Task 7.1: Implement Kill Switch
- [ ] Monitor VPN connection state changes
- [ ] Detect unexpected disconnections
- [ ] Block network traffic on disconnect (if supported)
- [ ] Add kill switch toggle in settings
- [ ] Restore traffic on reconnect

### Task 7.2: Implement Auto-Refresh
- [ ] Add app lifecycle listener
- [ ] Trigger server refresh on app resume
- [ ] Implement background refresh logic
- [ ] Add refresh timestamp display

### Task 7.3: Add Theme Support
- [ ] Define light theme colors
- [ ] Define dark theme colors
- [ ] Implement theme switching
- [ ] Persist theme preference

## Phase 8: Error Handling & Polish

### Task 8.1: Comprehensive Error Handling
- [ ] Add try-catch blocks to all async operations
- [ ] Display user-friendly error messages
- [ ] Implement retry mechanisms
- [ ] Add error logging for debugging
- [ ] Handle VPN permission denial
- [ ] Handle invalid configurations
- [ ] Handle network timeouts

### Task 8.2: Loading States
- [ ] Add loading indicators for all async operations
- [ ] Implement skeleton screens
- [ ] Add progress indicators for connection
- [ ] Disable buttons during operations

### Task 8.3: User Feedback
- [ ] Add snackbars for success/error messages
- [ ] Add haptic feedback for button presses
- [ ] Add connection sound notifications (optional)
- [ ] Add toast messages for background operations

## Phase 9: Testing & Optimization

### Task 9.1: Unit Tests
- [ ] Write tests for Base64 decoder
- [ ] Write tests for URI parser
- [ ] Write tests for config parser
- [ ] Write tests for use cases
- [ ] Write tests for providers

### Task 9.2: Integration Tests
- [ ] Test subscription fetching flow
- [ ] Test VPN connection flow
- [ ] Test server selection flow
- [ ] Test error scenarios

### Task 9.3: Performance Optimization
- [ ] Optimize server list rendering
- [ ] Implement lazy loading for large lists
- [ ] Optimize stats stream updates
- [ ] Reduce unnecessary rebuilds
- [ ] Profile app performance

### Task 9.4: Memory Management
- [ ] Ensure proper disposal of streams
- [ ] Cancel pending HTTP requests
- [ ] Clear cached data appropriately
- [ ] Fix memory leaks

## Phase 10: Deployment Preparation

### Task 10.1: Android Build Configuration
- [ ] Configure app signing
- [ ] Update app icons
- [ ] Set version number and build number
- [ ] Configure ProGuard rules
- [ ] Test release build

### Task 10.2: iOS Build Configuration
- [ ] Configure code signing
- [ ] Update app icons
- [ ] Set version and build number
- [ ] Configure release scheme
- [ ] Test release build

### Task 10.3: Documentation
- [ ] Write README.md with setup instructions
- [ ] Document API endpoints
- [ ] Add code comments
- [ ] Create user guide
- [ ] Document known issues

### Task 10.4: Final Testing
- [ ] Test on multiple Android devices
- [ ] Test on multiple iOS devices
- [ ] Test various network conditions
- [ ] Test with different server configurations
- [ ] Perform security audit

## Priority Order for MVP

**High Priority (Must Have)**:
1. Task 1.1 - 1.4: Project Setup
2. Task 2.1 - 2.4: Core Data Layer (Parser & Remote Source)
3. Task 3.1 - 3.3: Domain Layer
4. Task 4.1 - 4.2: Repository Implementation
5. Task 5.1 - 5.2: State Management
6. Task 6.1 - 6.3: UI Implementation
7. Task 8.1: Error Handling

**Medium Priority (Should Have)**:
8. Task 2.5: Local Cache
9. Task 4.3: Ping Service
10. Task 7.2: Auto-Refresh
11. Task 8.2 - 8.3: Loading States & Feedback

**Low Priority (Nice to Have)**:
12. Task 7.1: Kill Switch
13. Task 7.3: Theme Support
14. Task 9.1 - 9.4: Testing & Optimization
15. Task 10.1 - 10.4: Deployment Preparation
