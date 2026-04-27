enum ConnectionStatus {
  disconnected,
  connecting,
  connected,
  disconnecting,
  error,
}

class ConnectionStats {
  final Duration duration;
  final int uploadBytes;
  final int downloadBytes;
  final double uploadSpeed; // bytes per second
  final double downloadSpeed; // bytes per second
  final ConnectionStatus status;
  final String? errorMessage;

  const ConnectionStats({
    required this.duration,
    required this.uploadBytes,
    required this.downloadBytes,
    required this.uploadSpeed,
    required this.downloadSpeed,
    required this.status,
    this.errorMessage,
  });

  factory ConnectionStats.initial() {
    return const ConnectionStats(
      duration: Duration.zero,
      uploadBytes: 0,
      downloadBytes: 0,
      uploadSpeed: 0,
      downloadSpeed: 0,
      status: ConnectionStatus.disconnected,
    );
  }

  ConnectionStats copyWith({
    Duration? duration,
    int? uploadBytes,
    int? downloadBytes,
    double? uploadSpeed,
    double? downloadSpeed,
    ConnectionStatus? status,
    String? errorMessage,
  }) {
    return ConnectionStats(
      duration: duration ?? this.duration,
      uploadBytes: uploadBytes ?? this.uploadBytes,
      downloadBytes: downloadBytes ?? this.downloadBytes,
      uploadSpeed: uploadSpeed ?? this.uploadSpeed,
      downloadSpeed: downloadSpeed ?? this.downloadSpeed,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  String get formattedDuration {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  String get formattedUpload => _formatBytes(uploadBytes);
  String get formattedDownload => _formatBytes(downloadBytes);
  String get formattedUploadSpeed => '${_formatBytes(uploadSpeed.toInt())}/s';
  String get formattedDownloadSpeed => '${_formatBytes(downloadSpeed.toInt())}/s';

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(2)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  @override
  String toString() {
    return 'ConnectionStats(status: $status, duration: $formattedDuration, '
        'upload: $formattedUpload, download: $formattedDownload)';
  }
}
