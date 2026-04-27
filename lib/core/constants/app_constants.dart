class AppConstants {
  // Subscription URL
  static const String subscriptionUrl =
      'https://raw.githubusercontent.com/barry-far/V2ray-config/main/Sub1.txt';

  // Timeouts
  static const Duration httpTimeout = Duration(seconds: 10);
  static const Duration pingTimeout = Duration(seconds: 5);
  static const Duration reconnectDelay = Duration(seconds: 3);

  // Cache
  static const Duration cacheExpiry = Duration(hours: 24);
  static const String cachedServersKey = 'cached_servers';
  static const String cacheTimestampKey = 'cache_timestamp';
  static const String selectedServerKey = 'selected_server';

  // Protocols
  static const String protocolVMess = 'vmess';
  static const String protocolVLess = 'vless';

  // Connection
  static const int maxReconnectAttempts = 3;
  static const Duration statsUpdateInterval = Duration(seconds: 1);
}
