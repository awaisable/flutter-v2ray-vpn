import NetworkExtension

/// Minimal Packet Tunnel Provider stub.
/// The actual V2Ray tunneling is handled by the flutter_v2ray native bridge.
/// This target must exist and be signed with the NetworkExtension entitlement.
class PacketTunnelProvider: NEPacketTunnelProvider {

    override func startTunnel(
        options: [String: NSObject]?,
        completionHandler: @escaping (Error?) -> Void
    ) {
        // flutter_v2ray manages the tunnel lifecycle via its own native layer.
        // This stub satisfies the iOS requirement for a Packet Tunnel Provider target.
        completionHandler(nil)
    }

    override func stopTunnel(
        with reason: NEProviderStopReason,
        completionHandler: @escaping () -> Void
    ) {
        completionHandler()
    }

    override func handleAppMessage(
        _ messageData: Data,
        completionHandler: ((Data?) -> Void)?
    ) {
        completionHandler?(nil)
    }
}
