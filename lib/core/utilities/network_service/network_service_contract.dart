/// The interface definition for the [NetworkService] with respect to platform specific network status related information.
/// {@category Interface Contract}
abstract class NetworkServiceContract {
  /// This interface provides the current internet connection status or the disconnected status in error case.
  Future<bool> getConnectionStatus();
}
