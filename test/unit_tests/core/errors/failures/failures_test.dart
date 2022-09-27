import 'package:u_auth/core/errors/exceptions/exceptions.dart';
import 'package:u_auth/core/errors/failures/failures.dart';
import 'package:u_auth/core/utilities/constants.dart' as constants;
import 'package:flutter_test/flutter_test.dart';

import '../../../../test_utilities/fixtures/user_profile_fixtures.dart' as user_profile_fixtures;

/// Dart test cases for [MyFailures] error handling.
void main() {
  String getDefaultIdentifier() => user_profile_fixtures.defaultUserProfile.identifier;
  MyExceptions getInvalidPasswordException() => InvalidPasswordException(identifier: getDefaultIdentifier());

  test('should use the predefined failure code when a verification failure is instantiate.', () async {
    // (A)ct -> on the object or method under test.
    UserProfileVerificationFailure failure = UserProfileVerificationFailure(exceptionCause: getInvalidPasswordException());

    // (A)ssert -> that the expected results have occurred.
    expect(failure, isA<MyFailures>());
    expect(failure.props[0], constants.userProfileVerificationFailureCode);
  });

  test('should use the given identifier in the failure details message.', () async {
    // (A)ct -> on the object or method under test.
    UserProfileVerificationFailure failure = UserProfileVerificationFailure(exceptionCause: getInvalidPasswordException());

    // (A)ssert -> that the expected results have occurred.
    expect(failure, isA<MyFailures>());
    expect(failure.exceptionCause.exceptionDetails.contains(getDefaultIdentifier()), true);
  });

  test('should use the predefined failure code when a access failure is instantiate.', () async {
    // (A)ct -> on the object or method under test.
    UserProfileAccessFailure failure = const UserProfileAccessFailure(exceptionCause: CacheStorageReadException());
    // (A)ssert -> that the expected results have occurred.
    expect(failure, isA<MyFailures>());
    expect(failure.props[0], constants.userProfileAccessFailureCode);
  });
}
