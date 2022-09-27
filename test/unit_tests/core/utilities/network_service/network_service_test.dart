import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:u_auth/core/utilities/network_service/network_service.dart';

import '../../../../test_utilities/mocks/core_utilities.dart' as utility_mock;

/// Dart test cases for [NetworkStatus] API.
void main() {
  NetworkService networkService = NetworkService(utility_mock.internetConnectionChecker);

  test('should return true when requesting the internet connection status.', () async {
    // (A)rrange -> all necessary preconditions and inputs.
    when(utility_mock.internetConnectionChecker.hasConnection).thenAnswer((_) async => true);

    // (A)ct -> on the object or method under test.
    bool connectionStatusResult = await networkService.getConnectionStatus();

    // (A)ssert -> that the expected results have occurred.
    expect(connectionStatusResult, true);
    verify(utility_mock.internetConnectionChecker.hasConnection);
    verifyNoMoreInteractions(utility_mock.internetConnectionChecker);
  });
}
