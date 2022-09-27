import 'dart:async';

import 'package:u_auth/core/features/user_profile_authentication/data/models/user_profile_model.dart';
import 'package:u_auth/core/utilities/constants.dart';

/// Defines the interface for the [CacheStorage] with respect to [UserProfile] related data.
/// {@category Interface Contract}
abstract class CacheStorageContract {
  /// This interface provides the identifier associated [UserProfileModel] of the [CacheStorage].
  Future<UserProfileModel> readAuthData({required String identifier});

  /// This interface stores the given [UserProfileModel] to the [CacheStorage].
  Future<NoParams> writeAuthData({required UserProfileModel userProfileModel});
}