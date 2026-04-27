import 'package:flutter/material.dart';
import '../../domain/entities/traffic_stats.dart';

class SpeedWidget extends StatelessWidget {
  final TrafficStats stats;
  const SpeedWidget({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        children: [
          Expanded(
            child: _SpeedTile(
              icon: Icons.arrow_upward_rounded,
              color: const Color(0xFFFF6D00),
              label: 'Upload',
              speed: stats.uploadSpeedFormatted,
              total: stats.totalUploadFormatted,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _SpeedTile(
              icon: Icons.arrow_downward_rounded,
              color: const Color(0xFF00E676),
              label: 'Download',
              speed: stats.downloadSpeedFormatted,
              total: stats.totalDownloadFormatted,
            ),
          ),
        ],
      ),
    );
  }
}

class _SpeedTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String speed;
  final String total;

  const _SpeedTile({
    required this.icon,
    required this.color,
    required this.label,
    required this.speed,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(color: color, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            speed,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Total: $total',
            style: const TextStyle(color: Colors.white38, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
