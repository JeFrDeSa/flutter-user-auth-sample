import 'dart:convert';

import 'package:u_auth/core/features/user_profile_authentication/data/models/user_profile_model.dart';
import 'package:u_auth/core/features/user_profile_authentication/domain/entities/user_profile.dart';
import 'package:u_auth/core/utilities/constants.dart' as constants;
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../test_utilities/fixtures/user_profile_model_fixtures.dart' as user_profile_model_fixtures;

/// Dart test cases for the [UserProfileModel].
void main() {
  late UserProfileModel userProfileModel;

  setUp(() {
    userProfileModel = user_profile_model_fixtures.defaultUserProfileModel;
  });

  String getDefaultUserProfileModelJson() => user_profile_model_fixtures.defaultUserProfileModelJson;

  test('should be a subtype of the user profile entity.', () async {
    // (A)ssert -> that the expected results have occurred.
    expect(userProfileModel, isA<UserProfile>());
  });

  group('Json conversion', () {
    test('should return a valid user profile model from a json string when called.', () async {
      // (A)rrange -> all necessary preconditions and inputs.
      String jsonMapFixture = getDefaultUserProfileModelJson();

      // (A)ct -> on the object or method under test.
      UserProfileModel newUserProfileModel = UserProfileModel.fromJson(jsonMapFixture);

      // (A)ssert -> that the expected results have occurred.
      expect(newUserProfileModel.identifier, jsonDecode(jsonMapFixture)['identifier']);
      expect(newUserProfileModel.passwordHash, jsonDecode(jsonMapFixture)['passwordHash']);
      expect(newUserProfileModel.dataAvailability, constants.UserProfileDataState.isNotAvailable);
    });

    test('should return a valid json string of the user profile model when called.', () async {
      // (A)ct -> on the object or method under test.
      String jsonMap = userProfileModel.toJson();

      // (A)ssert -> that the expected results have occurred.
      expect(getDefaultUserProfileModelJson(), jsonMap);
    });
  });
}
