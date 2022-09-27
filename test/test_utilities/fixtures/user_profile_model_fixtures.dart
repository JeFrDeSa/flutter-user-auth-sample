import 'dart:io';

import 'package:u_auth/core/features/user_profile_authentication/data/models/user_profile_model.dart';

import 'user_profile_fixtures.dart' as user_profile_fixtures;

/// The default [UserProfileModel] test data.
final UserProfileModel defaultUserProfileModel = UserProfileModel(
  identifier: user_profile_fixtures.defaultUserProfile.identifier,
  passwordHash: user_profile_fixtures.defaultUserProfile.passwordHash,
);

/// The default [UserProfileModel] json string test data.
final String defaultUserProfileModelJson =
    File('test/test_utilities/fixtures/user_profile_model_user1.json').readAsStringSync();
