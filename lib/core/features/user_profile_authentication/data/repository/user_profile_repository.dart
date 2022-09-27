import 'package:u_auth/core/errors/exceptions/exceptions.dart';
import 'package:u_auth/core/errors/failures/failures.dart';
import 'package:u_auth/core/features/user_profile_authentication/domain/entities/user_profile.dart';
import 'package:u_auth/core/features/user_profile_authentication/domain/repository_contract/user_profile_repository_contract.dart';
import 'package:u_auth/core/utilities/cache_storage/cache_storage_contract.dart';
import 'package:u_auth/core/utilities/constants.dart';
import 'package:u_auth/core/utilities/constants.dart' as constants;
import 'package:u_auth/core/utilities/database_storage/database_storage.dart';
import 'package:u_auth/core/utilities/database_storage/database_storage_contract.dart';
import 'package:u_auth/core/utilities/network_service/network_service.dart';
import 'package:u_auth/core/utilities/network_service/network_service_contract.dart';
import 'package:dartz/dartz.dart';

import '../models/user_profile_model.dart';

/// Implements the interface for the access of to the stored user profile information.
/// {@category Repositories}
class UserProfileRepository implements UserProfileRepositoryContract {
  /// The interface for [CacheStorage] related data.
  final CacheStorageContract cacheStorageContract;

  /// The interface for [DatabaseStorage] related data.
  final DatabaseStorageContract databaseStorageContract;

  /// The interface for [NetworkService] related data.
  final NetworkServiceContract networkServiceContract;

  /// The model that is referred by all repository methods.
  late UserProfileModel _activeUserProfile;

  /// Creates a repository that use the following contracts for its services.
  /// * [CacheStorageContract]
  /// * [DatabaseStorageContract]
  /// * [NetworkServiceContract]
  UserProfileRepository({
    required this.cacheStorageContract,
    required this.databaseStorageContract,
    required this.networkServiceContract,
  });

  @override
  Future<Either<MyFailures, UserProfile>> loadAuthData({required String identifier}) async {
    try {
      if (await _checkInternetConnectionStatus()) {
        _activeUserProfile = await databaseStorageContract.readAuthData(identifier: identifier);
      } else {
        _activeUserProfile = await cacheStorageContract.readAuthData(identifier: identifier);
      }
    } on DataEntryNotFoundException catch (ex) {
      return Left(UserProfileVerificationFailure(exceptionCause: ex));
    } on MyExceptions catch (ex) {
      return Left(UserProfileAccessFailure(exceptionCause: ex));
    }
    return Right(_activeUserProfile);
  }

  @override
  Future<Either<MyFailures, UserProfile>> storeAuthData({required String identifier, required String passwordHash}) async {
    _setActiveUserProfile(identifier: identifier, passwordHash: passwordHash);
    try {
      if (await _checkInternetConnectionStatus()) {
        await databaseStorageContract.writeAuthData(userProfileModel: _activeUserProfile);
      } else {
        await cacheStorageContract.writeAuthData(userProfileModel: _activeUserProfile);
      }
    } on MyExceptions catch (ex) {
      return Left(UserProfileAccessFailure(exceptionCause: ex));
    }
    return Right(_activeUserProfile);
  }

  /// Sets the [_activeUserProfile] based on the given login credentials.
  void _setActiveUserProfile({required String identifier, required String passwordHash}) {
    _activeUserProfile = UserProfileModel(identifier: identifier, passwordHash: passwordHash);
  }

  @override
  Future<Either<MyFailures, NoParams>> preloadUserProfileData() async {
    if (await _checkInternetConnectionStatus()) {
      // ToDo: Add user profile data related database request here
    } else {
      // ToDo: Add user profile data related cache request here
    }
    await Future.delayed(const Duration(milliseconds: 250)).then((_) {
      _activeUserProfile.updateDataAvailability(constants.UserProfileDataState.isAvailable);
    });

    return Right(NoParams());
  }

  /// Returns the current internet connection status.
  Future<bool> _checkInternetConnectionStatus() async {
    return await networkServiceContract.getConnectionStatus();
  }
}
