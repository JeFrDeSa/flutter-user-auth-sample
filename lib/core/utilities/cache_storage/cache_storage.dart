import 'dart:convert';

import 'package:u_auth/core/errors/exceptions/exceptions.dart';
import 'package:u_auth/core/features/user_profile_authentication/data/models/user_profile_model.dart';
import 'package:u_auth/core/utilities/cache_storage/cache_storage_contract.dart';
import 'package:u_auth/core/utilities/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Implements the interface for the access of user profile information of the cache.
///
/// The cache storage implements [SharedPreferences] for storing [UserProfileModel] related data.
class CacheStorage implements CacheStorageContract {
  /// The persistent storage of the cache.
  final SharedPreferences sharedPreferences;

  /// Creates the cache storage by using [SharedPreferences].
  CacheStorage(this.sharedPreferences);

  @override
  Future<UserProfileModel> readAuthData({required String identifier}) async {
    try {
      return UserProfileModel.fromJson(jsonDecode(sharedPreferences.getString(identifier)!));
    } on CastError {
      throw const DataEntryNotFoundException();
    } catch (ex) {
      throw const CacheStorageReadException();
    }
  }

  @override
  Future<NoParams> writeAuthData({required UserProfileModel userProfileModel}) async {
    if (await _executeWriteAuthData(userProfileModel: userProfileModel)) {
      return NoParams();
    } else {
      throw const CacheStorageWriteException();
    }
  }

  /// Executes the actual write action and returns whether it was successful or not
  Future<bool> _executeWriteAuthData({required UserProfileModel userProfileModel}) async {
    try{
      return await sharedPreferences.setString(userProfileModel.identifier, jsonEncode(userProfileModel.toJson()));
    } catch(ex) {
      return false;
    }
  }
}
