import 'dart:convert';

import 'package:u_auth/core/errors/exceptions/exceptions.dart';
import 'package:u_auth/core/features/user_profile_authentication/data/models/user_profile_model.dart';
import 'package:u_auth/core/utilities/cache_storage/cache_storage.dart';
import 'package:u_auth/core/utilities/constants.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../test_utilities/fixtures/user_profile_model_fixtures.dart' as user_profile_model_fixtures;
import '../../../../test_utilities/mocks/core_utilities.dart' as core_utilities;

/// Dart test cases for [CacheStorage] API.
void main() {
  final CacheStorage cacheStorage = CacheStorage(core_utilities.sharedPreferences);

  String getDefaultModelIdentifier() => user_profile_model_fixtures.defaultUserProfileModel.identifier;
  UserProfileModel getDefaultUserProfileModel() => user_profile_model_fixtures.defaultUserProfileModel;
  String getDefaultUserProfileModelJsonStr() => jsonEncode(user_profile_model_fixtures.defaultUserProfileModel.toJson());

  group('Request user profile authentication data.', () {
    void sharedPreferencesAnswerWhenGetStringCalled(String identifier, String returnValue) {
      when(core_utilities.sharedPreferences.getString(identifier)).thenAnswer((_) => returnValue);
    }

    void sharedPreferencesThrowWhenGetStringCalled(String identifier, Exception returnValue) {
      when(core_utilities.sharedPreferences.getString(identifier)).thenThrow((returnValue));
    }

    void verifyOnlySharedPreferencesGetStringCalled(String identifier) {
      verify(core_utilities.sharedPreferences.getString(identifier));
      verifyNoMoreInteractions(core_utilities.sharedPreferences);
    }

    test('should read the current user profile model from the local cache.', () async {
      // (A)rrange -> all necessary preconditions and inputs.
      sharedPreferencesAnswerWhenGetStringCalled(getDefaultModelIdentifier(), getDefaultUserProfileModelJsonStr());

      // (A)ct -> on the object or method under test.
      UserProfileModel cacheStorageResult = await cacheStorage.readAuthData(identifier: getDefaultModelIdentifier());

      // (A)ssert -> that the expected results have occurred.
      expect(cacheStorageResult, getDefaultUserProfileModel());
      verifyOnlySharedPreferencesGetStringCalled(getDefaultModelIdentifier());
    });

    test('should throw a cache storage read exception when reading caused an exception.', () async {
      // (A)rrange -> all necessary preconditions and inputs.
      bool exceptionOccurred = false;
      sharedPreferencesThrowWhenGetStringCalled(getDefaultModelIdentifier(), Exception("General valid exception"));

      // (A)ct -> on the object or method under test.
      try {
        await cacheStorage.readAuthData(identifier: getDefaultModelIdentifier());
      } on CacheStorageReadException {
        exceptionOccurred = true;
      }

      // (A)ssert -> that the expected results have occurred.
      expect(exceptionOccurred, true);
      verifyOnlySharedPreferencesGetStringCalled(getDefaultModelIdentifier());
    });

    test('should throw a no data entry found exception when the requested identifier could not be found.', () async {
      // (A)rrange -> all necessary preconditions and inputs.
      bool exceptionOccurred = false;
      //ToDo: Fix CastError issue - Is deprecated but used by SharedPreferences
      when(core_utilities.sharedPreferences.getString(getDefaultModelIdentifier())).thenThrow(CastError());

      // (A)ct -> on the object or method under test.
      try {
        await cacheStorage.readAuthData(identifier: getDefaultModelIdentifier());
      } on DataEntryNotFoundException {
        exceptionOccurred = true;
      }

      // (A)ssert -> that the expected results have occurred.
      expect(exceptionOccurred, true);
      verifyOnlySharedPreferencesGetStringCalled(getDefaultModelIdentifier());
    });
  });

  group('Store user profile authentication data.', () {
    void sharedPreferencesAnswerWhenSetStringCalled(String identifier, String userProfileJson, bool returnValue) {
      when(core_utilities.sharedPreferences.setString(identifier, userProfileJson)).thenAnswer((_) async => returnValue);
    }

    void sharedPreferencesThrowWhenSetStringCalled(String identifier, String userProfileJson, Exception returnValue) {
      when(core_utilities.sharedPreferences.setString(identifier, userProfileJson)).thenThrow((returnValue));
    }

    void verifyOnlySharedPreferencesSetStringCalled(String identifier, String userProfileJson) {
      verify(core_utilities.sharedPreferences.setString(identifier, userProfileJson));
      verifyNoMoreInteractions(core_utilities.sharedPreferences);
    }

    Future<bool> exceptionDuringWriteAuthData() async {
      try {
        await cacheStorage.writeAuthData(userProfileModel: getDefaultUserProfileModel());
      } on CacheStorageWriteException {
        return true;
      }
      return false;
    }

    test('should write the given user profile model to the local cache.', () async {
      // (A)rrange -> all necessary preconditions and inputs.
      sharedPreferencesAnswerWhenSetStringCalled(getDefaultModelIdentifier(), getDefaultUserProfileModelJsonStr(), true);

      // (A)ct -> on the object or method under test.
      NoParams cacheStorageResult = await cacheStorage.writeAuthData(userProfileModel: getDefaultUserProfileModel());

      // (A)ssert -> that the expected results have occurred.
      expect(cacheStorageResult, isA<NoParams>());
      verifyOnlySharedPreferencesSetStringCalled(getDefaultModelIdentifier(), getDefaultUserProfileModelJsonStr());
    });

    test('should throw a cache storage write exception when writing to the cache storage fails.', () async {
      // (A)rrange -> all necessary preconditions and inputs.
      bool exceptionOccurred = false;
      sharedPreferencesAnswerWhenSetStringCalled(getDefaultModelIdentifier(), getDefaultUserProfileModelJsonStr(), false);

      // (A)ct -> on the object or method under test.
      exceptionOccurred = await exceptionDuringWriteAuthData();

      // (A)ssert -> that the expected results have occurred.
      expect(exceptionOccurred, true);
      verifyOnlySharedPreferencesSetStringCalled(getDefaultModelIdentifier(), getDefaultUserProfileModelJsonStr());
    });

    test('should throw a cache storage write exception when writing caused an exception.', () async {
      // (A)rrange -> all necessary preconditions and inputs.
      bool exceptionOccurred = false;
      Exception exception = Exception("General valid exception");
      sharedPreferencesThrowWhenSetStringCalled(getDefaultModelIdentifier(), getDefaultUserProfileModelJsonStr(), exception);

      // (A)ct -> on the object or method under test.
      exceptionOccurred = await exceptionDuringWriteAuthData();

      // (A)ssert -> that the expected results have occurred.
      expect(exceptionOccurred, true);
      verifyOnlySharedPreferencesSetStringCalled(getDefaultModelIdentifier(), getDefaultUserProfileModelJsonStr());
    });
  });
}
