import 'package:u_auth/core/errors/failures/failures.dart';
import 'package:u_auth/core/utilities/constants.dart';
import 'package:dartz/dartz.dart';

import '../entities/user_profile.dart';

/// Defines the interface for the [UserProfileRepository] with respect to [UserProfile] related data.
/// {@category Interface Contract}
abstract class UserProfileRepositoryContract {
  /// This interface provides read access of the data storage.
  Future<Either<MyFailures, UserProfile>> loadAuthData({required String identifier});

  /// This interface provides write access to the data storages.
  ///
  /// Returns a [UserProfile] entity based on the provided login credentials if successfully stored.
  Future<Either<MyFailures, UserProfile>> storeAuthData({required String identifier, required String passwordHash});

  /// This interface executes the loading of user profile related data.
  ///
  /// Informs the listeners of the loaded [UserProfile] about an update of the data availability state.
  Future<Either<MyFailures, NoParams>> preloadUserProfileData();
}
