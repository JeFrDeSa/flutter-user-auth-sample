import 'package:u_auth/core/features/user_profile_authentication/data/models/user_profile_model.dart';
import 'package:u_auth/core/utilities/constants.dart';
import 'package:u_auth/core/utilities/database_storage/database_storage_contract.dart';

/// Implements the interface for the access of user profile information of the database.
///
/// The database storage implements [...] for storing [UserProfileModel] related data.
class DatabaseStorage implements DatabaseStorageContract {
  /// The persistent storage of the database.

  /// Creates the database storage by using [...].
  DatabaseStorage();

  @override
  Future<UserProfileModel> readAuthData({required String identifier}) {
    // TODO: implement readAuthData
    throw UnimplementedError();
  }

  @override
  Future<NoParams> writeAuthData({required UserProfileModel userProfileModel}) {
    // TODO: implement writeAuthData
    throw UnimplementedError();
  }
}