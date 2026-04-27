import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/server_provider.dart';
import '../../domain/entities/server_config.dart';

class ServerListScreen extends StatefulWidget {
  const ServerListScreen({super.key});

  @override
  State<ServerListScreen> createState() => _ServerListScreenState();
}

class _ServerListScreenState extends State<ServerListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Server'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<ServerProvider>().refreshServers(forceRefresh: true);
            },
          ),
        ],
      ),
      body: Consumer<ServerProvider>(
        builder: (context, serverProvider, child) {
          return Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search servers...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              serverProvider.searchServers('');
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) {
                    serverProvider.searchServers(value);
                  },
                ),
              ),
              
              // Server Count
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Text(
                      '${serverProvider.filteredServers.length} servers',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Server List
              Expanded(
                child: serverProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : serverProvider.filteredServers.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No servers found',
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: () => serverProvider.refreshServers(
                              forceRefresh: true,
                            ),
                            child: ListView.builder(
                              itemCount: serverProvider.filteredServers.length,
                              itemBuilder: (context, index) {
                                final server = serverProvider.filteredServers[index];
                                final isSelected = serverProvider.selectedServer?.id == server.id;
                                
                                return _ServerListItem(
                                  server: server,
                                  isSelected: isSelected,
                                  onTap: () {
                                    serverProvider.selectServer(server);
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Selected: ${server.remark}'),
                                        duration: const Duration(seconds: 2),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ServerListItem extends StatelessWidget {
  final ServerConfig server;
  final bool isSelected;
  final VoidCallback onTap;

  const _ServerListItem({
    required this.server,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: isSelected ? 4 : 1,
      color: isSelected
          ? Theme.of(context).colorScheme.primaryContainer
          : null,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.grey[300],
          child: Icon(
            server.protocol == 'vmess' ? Icons.vpn_key : Icons.vpn_lock,
            color: isSelected ? Colors.white : Colors.grey[700],
          ),
        ),
        title: Text(
          server.remark,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('${server.protocol}://${server.address}:${server.port}'),
            const SizedBox(height: 2),
            Row(
              children: [
                Icon(
                  Icons.network_check,
                  size: 14,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  server.latency != null
                      ? '${server.latency}ms'
                      : 'Not tested',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: isSelected
            ? Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
              )
            : const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
