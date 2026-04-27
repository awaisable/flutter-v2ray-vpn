import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/server_config.dart';
import '../providers/providers.dart';

class ServerTile extends ConsumerWidget {
  final ServerConfig server;
  final VoidCallback onTap;

  const ServerTile({super.key, required this.server, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedServerProvider);
    final isSelected = selected?.id == server.id;
    final pingAsync = ref.watch(pingProvider(server));

    return ListTile(
      tileColor: isSelected
          ? const Color(0xFF448AFF).withOpacity(0.12)
          : Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: _ProtocolBadge(protocol: server.protocol),
      title: Text(
        server.remark,
        style: TextStyle(
          color: isSelected ? const Color(0xFF448AFF) : Colors.white,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 14,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '${server.address}:${server.port}',
        style: const TextStyle(color: Colors.white38, fontSize: 12),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: _PingBadge(pingAsync: pingAsync),
      onTap: onTap,
    );
  }
}

class _ProtocolBadge extends StatelessWidget {
  final String protocol;
  const _ProtocolBadge({required this.protocol});

  Color get _color {
    switch (protocol) {
      case 'vmess':
        return const Color(0xFF448AFF);
      case 'vless':
        return const Color(0xFF00E676);
      case 'trojan':
        return const Color(0xFFFF6D00);
      case 'ss':
        return const Color(0xFFAA00FF);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: _color.withOpacity(0.4)),
      ),
      child: Text(
        protocol.toUpperCase(),
        style: TextStyle(
          color: _color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _PingBadge extends StatelessWidget {
  final AsyncValue<int> pingAsync;
  const _PingBadge({required this.pingAsync});

  @override
  Widget build(BuildContext context) {
    return pingAsync.when(
      loading: () => const SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white24),
      ),
      error: (_, __) => const Text(
        'N/A',
        style: TextStyle(color: Colors.white24, fontSize: 12),
      ),
      data: (ms) {
        if (ms < 0) {
          return const Text(
            'Timeout',
            style: TextStyle(color: Colors.red, fontSize: 12),
          );
        }
        final color = ms < 150
            ? const Color(0xFF00E676)
            : ms < 300
                ? const Color(0xFFFFB300)
                : Colors.red;
        return Text(
          '${ms}ms',
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        );
      },
    );
  }
}
