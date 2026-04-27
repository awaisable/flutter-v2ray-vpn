class TrafficStats {
  final double uploadSpeed;   // bytes/s
  final double downloadSpeed; // bytes/s
  final int totalUpload;      // bytes
  final int totalDownload;    // bytes

  const TrafficStats({
    this.uploadSpeed = 0,
    this.downloadSpeed = 0,
    this.totalUpload = 0,
    this.totalDownload = 0,
  });

  static const TrafficStats zero = TrafficStats();

  String get uploadSpeedFormatted => _formatSpeed(uploadSpeed);
  String get downloadSpeedFormatted => _formatSpeed(downloadSpeed);
  String get totalUploadFormatted => _formatBytes(totalUpload);
  String get totalDownloadFormatted => _formatBytes(totalDownload);

  static String _formatSpeed(double bytesPerSec) {
    if (bytesPerSec >= 1024 * 1024) {
      return '${(bytesPerSec / (1024 * 1024)).toStringAsFixed(1)} MB/s';
    } else if (bytesPerSec >= 1024) {
      return '${(bytesPerSec / 1024).toStringAsFixed(1)} KB/s';
    }
    return '${bytesPerSec.toStringAsFixed(0)} B/s';
  }

  static String _formatBytes(int bytes) {
    if (bytes >= 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
    } else if (bytes >= 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    } else if (bytes >= 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    return '$bytes B';
  }
}
