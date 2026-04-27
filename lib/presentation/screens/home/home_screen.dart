import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/vpn_status.dart';
import '../../providers/providers.dart';
import '../../widgets/speed_widget.dart';
import '../../widgets/status_badge.dart';
import '../servers/server_list_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vpnAsync = ref.watch(vpnStatusProvider);
    final selectedServer = ref.watch(selectedServerProvider);
    final traffic = ref.watch(trafficStatsProvider).valueOrNull;

    final status = vpnAsync.valueOrNull ?? VpnStatus.initial;
    final isConnected = status.isConnected;
    final isConnecting = status.isConnecting;

    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'V2Ray VPN',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.dns_rounded, color: Colors.white70),
            tooltip: 'Server List',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ServerListScreen()),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 32),

            // Status Badge
            StatusBadge(state: status.state),
            const SizedBox(height: 8),

            // Selected server name
            Text(
              selectedServer?.remark ?? 'No server selected',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 14,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 48),

            // Connect Toggle Button
            _ConnectButton(
              isConnected: isConnected,
              isConnecting: isConnecting,
              onTap: () => _handleToggle(context, ref, status),
            ),

            const SizedBox(height: 48),

            // Duration
            if (isConnected)
              _DurationTile(duration: status.duration)
                  .animate()
                  .fadeIn(duration: 400.ms),

            const SizedBox(height: 16),

            // Speed Widget
            if (isConnected && traffic != null)
              SpeedWidget(stats: traffic).animate().fadeIn(duration: 400.ms),

            const Spacer(),

            // Pick Server Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white70,
                  side: const BorderSide(color: Colors.white24),
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.list_rounded),
                label: const Text('Pick Server'),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ServerListScreen()),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleToggle(
    BuildContext context,
    WidgetRef ref,
    VpnStatus status,
  ) async {
    if (status.isConnected || status.isConnecting) {
      await ref.read(disconnectVpnUseCaseProvider).call();
      return;
    }

    final server = ref.read(selectedServerProvider);
    if (server == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a server first.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final failure = await ref.read(connectVpnUseCaseProvider).call(server);
    if (failure != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(failure.message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }
}

// ── Connect Button ─────────────────────────────────────────────────────────────

class _ConnectButton extends StatelessWidget {
  final bool isConnected;
  final bool isConnecting;
  final VoidCallback onTap;

  const _ConnectButton({
    required this.isConnected,
    required this.isConnecting,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isConnected
        ? const Color(0xFF00E676)
        : isConnecting
            ? const Color(0xFFFFB300)
            : const Color(0xFF448AFF);

    return GestureDetector(
      onTap: isConnecting ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 160,
        height: 160,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withOpacity(0.12),
          border: Border.all(color: color, width: 3),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 32,
              spreadRadius: 4,
            ),
          ],
        ),
        child: Center(
          child: isConnecting
              ? CircularProgressIndicator(color: color, strokeWidth: 3)
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isConnected
                          ? Icons.power_settings_new_rounded
                          : Icons.power_settings_new_rounded,
                      color: color,
                      size: 48,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isConnected ? 'Disconnect' : 'Connect',
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

// ── Duration Tile ──────────────────────────────────────────────────────────────

class _DurationTile extends StatelessWidget {
  final Duration duration;
  const _DurationTile({required this.duration});

  String _format(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.timer_outlined, color: Colors.white38, size: 18),
        const SizedBox(width: 6),
        Text(
          _format(duration),
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 22,
            fontFamily: 'monospace',
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }
}
