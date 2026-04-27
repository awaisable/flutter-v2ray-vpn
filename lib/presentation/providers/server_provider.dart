import 'package:flutter/foundation.dart';
import '../../domain/entities/server_config.dart';
import '../../domain/repositories/subscription_repository.dart';

class ServerProvider with ChangeNotifier {
  final SubscriptionRepository subscriptionRepository;

  ServerProvider({required this.subscriptionRepository});

  List<ServerConfig> _servers = [];
  List<ServerConfig> _filteredServers = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';
  ServerConfig? _selectedServer;

  List<ServerConfig> get servers => _servers;
  List<ServerConfig> get filteredServers => _filteredServers;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  ServerConfig? get selectedServer => _selectedServer;
  bool get hasServers => _servers.isNotEmpty;

  Future<void> refreshServers({bool forceRefresh = false}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _servers = await subscriptionRepository.fetchServers(
        forceRefresh: forceRefresh,
      );
      _applySearchFilter();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _servers = [];
      _filteredServers = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchServers(String query) {
    _searchQuery = query;
    _applySearchFilter();
    notifyListeners();
  }

  void _applySearchFilter() {
    if (_searchQuery.isEmpty) {
      _filteredServers = List.from(_servers);
    } else {
      _filteredServers = _servers
          .where((server) =>
              server.remark.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              server.address.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
  }

  void selectServer(ServerConfig server) {
    _selectedServer = server;
    notifyListeners();
  }

  Future<void> pingServer(ServerConfig server) async {
    // TODO: Implement ping functionality using flutter_v2ray
    // This will be implemented when integrating the VPN service
    notifyListeners();
  }

  Future<void> pingAllServers() async {
    // TODO: Implement ping all functionality
    // This will ping servers in batches to avoid overwhelming the system
  }

  Future<void> clearCache() async {
    try {
      await subscriptionRepository.clearCache();
      _servers = [];
      _filteredServers = [];
      _selectedServer = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to clear cache: $e';
      notifyListeners();
    }
  }
}
