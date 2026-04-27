enum VpnState { disconnected, connecting, connected, disconnecting, error }

class VpnStatus {
  final VpnState state;
  final Duration duration;
  final String? errorMessage;

  const VpnStatus({
    required this.state,
    this.duration = Duration.zero,
    this.errorMessage,
  });

  static const VpnStatus initial = VpnStatus(state: VpnState.disconnected);

  bool get isConnected => state == VpnState.connected;
  bool get isConnecting => state == VpnState.connecting;
  bool get isDisconnected =>
      state == VpnState.disconnected || state == VpnState.error;

  VpnStatus copyWith({
    VpnState? state,
    Duration? duration,
    String? errorMessage,
  }) =>
      VpnStatus(
        state: state ?? this.state,
        duration: duration ?? this.duration,
        errorMessage: errorMessage ?? this.errorMessage,
      );
}
