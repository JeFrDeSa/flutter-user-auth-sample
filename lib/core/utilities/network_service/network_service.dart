import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:u_auth/core/utilities/network_service/network_service_contract.dart';

/// Implements the interface for requesting the current network connection status.
///
/// The network service implements [InternetConnectionChecker] for requesting the connection status.
/// {@category Android}
class NetworkService implements NetworkServiceContract {
  /// The underlying service for the connection status.
  final InternetConnectionChecker internetConnectionChecker;

  /// Creates the cache storage by using [SharedPreferences].
  NetworkService(this.internetConnectionChecker);

  @override
  Future<bool> getConnectionStatus() async {
    try {
      return await internetConnectionChecker.hasConnection;
    } on Exception {
      return false;
    }
  }
}
