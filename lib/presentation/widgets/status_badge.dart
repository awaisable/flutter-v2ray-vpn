import 'package:flutter/material.dart';
import '../../domain/entities/vpn_status.dart';

class StatusBadge extends StatelessWidget {
  final VpnState state;
  const StatusBadge({super.key, required this.state});

  String get _label {
    switch (state) {
      case VpnState.connected:
        return 'CONNECTED';
      case VpnState.connecting:
        return 'CONNECTING';
      case VpnState.disconnecting:
        return 'DISCONNECTING';
      case VpnState.error:
        return 'ERROR';
      case VpnState.disconnected:
        return 'DISCONNECTED';
    }
  }

  Color get _color {
    switch (state) {
      case VpnState.connected:
        return const Color(0xFF00E676);
      case VpnState.connecting:
      case VpnState.disconnecting:
        return const Color(0xFFFFB300);
      case VpnState.error:
        return Colors.red;
      case VpnState.disconnected:
        return Colors.white38;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _color.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _color,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            _label,
            style: TextStyle(
              color: _color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
