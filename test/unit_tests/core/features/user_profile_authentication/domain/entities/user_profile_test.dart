import 'package:u_auth/core/features/user_profile_authentication/domain/entities/user_profile.dart';
import 'package:u_auth/core/utilities/constants.dart' as constants;
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../test_utilities/fixtures/user_profile_fixtures.dart' as user_profile_fixtures;

/// Dart test cases for the [UserProfile] entity.
void main() {
  late UserProfile userProfile;

  setUp(() {
    userProfile = user_profile_fixtures.defaultUserProfile;
  });

  test('should provide the identifier and passwordHash.', () async {
    // (A)rrange -> all necessary preconditions and inputs.
    String identifier = userProfile.identifier;
    String passwordHash = userProfile.passwordHash;

    // (A)ssert -> that the expected results have occurred.
    expect(identifier, user_profile_fixtures.defaultUserProfile.identifier);
    expect(passwordHash, user_profile_fixtures.defaultUserProfile.passwordHash);
  });

  test('should initially indicate there are no data available.', () async {
    // (A)rrange -> all necessary preconditions and inputs.
    constants.UserProfileDataState initialDataAvailableState = userProfile.dataAvailability;

    // (A)ssert -> that the expected results have occurred.
    expect(initialDataAvailableState, constants.UserProfileDataState.isNotAvailable);
  });

  test('should call the listener when the data availability is updated.', () async {
    // (A)rrange -> all necessary preconditions and inputs.
    constants.UserProfileDataState updatedDataAvailableState = constants.UserProfileDataState.isNotAvailable;
    userProfile.addListener(() {
      updatedDataAvailableState = constants.UserProfileDataState.isAvailable;
    });

    // (A)ct -> on the object or method under test.
    constants.UserProfileDataState initialDataAvailableState = userProfile.dataAvailability;
    userProfile.updateDataAvailability(constants.UserProfileDataState.isAvailable);

    // (A)ssert -> that the expected results have occurred.
    expect(initialDataAvailableState, constants.UserProfileDataState.isNotAvailable);
    expect(updatedDataAvailableState, constants.UserProfileDataState.isAvailable);
  });
}
