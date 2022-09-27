import 'dart:async';

import 'package:u_auth/core/features/user_profile_authentication/data/models/user_profile_model.dart';
import 'package:u_auth/core/utilities/constants.dart';

/// The interface definition for the [DatabaseStorage] with respect to user profile related authentication data.
/// {@category Interface Contract}
abstract class DatabaseStorageContract {
  /// This interface provides the identifier associated [UserProfileModel] of the [DatabaseStorage].
  Future<UserProfileModel> readAuthData({required String identifier});

  /// This interface stores the given [UserProfileModel] to the [DatabaseStorage].
  Future<NoParams> writeAuthData({required UserProfileModel userProfileModel});
}