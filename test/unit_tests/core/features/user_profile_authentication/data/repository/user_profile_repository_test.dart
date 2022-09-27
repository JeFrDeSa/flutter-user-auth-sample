import 'package:u_auth/core/errors/exceptions/exceptions.dart';
import 'package:u_auth/core/errors/failures/failures.dart';
import 'package:u_auth/core/features/user_profile_authentication/data/models/user_profile_model.dart';
import 'package:u_auth/core/features/user_profile_authentication/data/repository/user_profile_repository.dart';
import 'package:u_auth/core/features/user_profile_authentication/domain/entities/user_profile.dart';
import 'package:u_auth/core/utilities/constants.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../../../test_utilities/fixtures/user_profile_model_fixtures.dart' as user_profile_model_fixtures;
import '../../../../../../test_utilities/mocks/core_utilities.dart' as core_utilities;

/// Dart test cases for the [UserProfileRepository].
void main() {
  late UserProfileRepository userProfileRepository;

  setUp(() {
    userProfileRepository = UserProfileRepository(
        databaseStorageContract: core_utilities.databaseStorage,
        cacheStorageContract: core_utilities.cacheStorage,
        networkServiceContract: core_utilities.networkService);
  });

  String getDefaultIdentifier() => user_profile_model_fixtures.defaultUserProfileModel.identifier;
  String getDefaultPasswordHash() => user_profile_model_fixtures.defaultUserProfileModel.passwordHash;
  UserProfileModel getDefaultUserProfileModel() => user_profile_model_fixtures.defaultUserProfileModel;

  void whenGetNetworkConnectionStatusCalled(bool returnValue) {
    when(core_utilities.networkService.getConnectionStatus()).thenAnswer((_) async => returnValue);
  }

  void verifyFailureDetails(Either<MyFailures, UserProfile> repositoryFailure, MyExceptions exceptionCause) {
    repositoryFailure.fold((failure) {
      expect(failure.exceptionCause.exceptionDetails, exceptionCause.exceptionDetails);
    }, (userProfile) {});
  }

  void verifyFailureType(Either<MyFailures, UserProfile> repositoryFailure, MyFailures matcher) {
    repositoryFailure.fold((failure) {
      expect(failure, matcher);
    }, (userProfile) {});
  }

  group('Verify Load Authentication Data', () {
    Future<Either<MyFailures, UserProfile>> callLoadAuthenticationData() async {
      return await userProfileRepository.loadAuthData(identifier: getDefaultIdentifier());
    }

    group('Check return values while network is online', () {
      setUp(() {
        whenGetNetworkConnectionStatusCalled(true);
      });

      void databaseAnswerWhenReadAuthDataCalled(String identifier, UserProfileModel returnValue) {
        when(core_utilities.databaseStorage.readAuthData(identifier: identifier)).thenAnswer((_) async => returnValue);
      }

      void databaseThrowWhenReadAuthDataCalled(String identifier, MyExceptions returnValue) {
        when(core_utilities.databaseStorage.readAuthData(identifier: identifier)).thenThrow(returnValue);
      }

      Future<void> verifyRepositoryReadInteractionWithDatabase(String identifier) async {
        verify(core_utilities.networkService.getConnectionStatus());
        assert(await core_utilities.networkService.getConnectionStatus() == true);
        verify(core_utilities.databaseStorage.readAuthData(identifier: identifier));
        verifyNoMoreInteractions(core_utilities.cacheStorage);
        verifyNoMoreInteractions(core_utilities.databaseStorage);
      }

      test('should return the requested user profile model from database when loading the data was successful.', () async {
        // (A)rrange -> all necessary preconditions and inputs.
        databaseAnswerWhenReadAuthDataCalled(getDefaultIdentifier(), getDefaultUserProfileModel());

        // (A)ct -> on the object or method under test.
        Either<MyFailures, UserProfile> userProfileRepositoryResult = await callLoadAuthenticationData();

        // (A)ssert -> that the expected results have occurred.
        assert(userProfileRepositoryResult.isRight());
        await verifyRepositoryReadInteractionWithDatabase(getDefaultIdentifier());
      });

      test('should return a verification failure when loading the data from database was not successful.', () async {
        // (A)rrange -> all necessary preconditions and inputs.
        DataEntryNotFoundException exception = const DataEntryNotFoundException();
        databaseThrowWhenReadAuthDataCalled(getDefaultIdentifier(), exception);

        // (A)ct -> on the object or method under test.
        Either<MyFailures, UserProfile> userProfileRepositoryResult = await callLoadAuthenticationData();

        // (A)ssert -> that the expected results have occurred.
        assert(userProfileRepositoryResult.isLeft());
        verifyFailureType(userProfileRepositoryResult, UserProfileVerificationFailure(exceptionCause: exception));
        verifyFailureDetails(userProfileRepositoryResult, exception);
        await verifyRepositoryReadInteractionWithDatabase(getDefaultIdentifier());
      });

      test('should return an access failure when loading the data from database was not successful.', () async {
        // (A)rrange -> all necessary preconditions and inputs.
        DatabaseStorageReadException exception = const DatabaseStorageReadException();
        databaseThrowWhenReadAuthDataCalled(getDefaultIdentifier(), exception);

        // (A)ct -> on the object or method under test.
        Either<MyFailures, UserProfile> userProfileRepositoryResult = await callLoadAuthenticationData();

        // (A)ssert -> that the expected results have occurred.
        assert(userProfileRepositoryResult.isLeft());
        verifyFailureDetails(userProfileRepositoryResult, exception);
        await verifyRepositoryReadInteractionWithDatabase(getDefaultIdentifier());
      });
    });

    group('Check return values while network is offline', () {
      setUp(() {
        whenGetNetworkConnectionStatusCalled(false);
      });

      void cacheAnswerWhenReadAuthDataCalled(String identifier, UserProfileModel returnValue) {
        when(core_utilities.cacheStorage.readAuthData(identifier: identifier)).thenAnswer((_) async => returnValue);
      }

      void cacheThrowWhenReadAuthDataCalled(String identifier, MyExceptions returnValue) {
        when(core_utilities.cacheStorage.readAuthData(identifier: identifier)).thenThrow(returnValue);
      }

      Future<void> verifyRepositoryReadInteractionWithCache(String identifier) async {
        verify(core_utilities.networkService.getConnectionStatus());
        assert(await core_utilities.networkService.getConnectionStatus() == false);
        verify(core_utilities.cacheStorage.readAuthData(identifier: identifier));
        verifyNoMoreInteractions(core_utilities.cacheStorage);
        verifyNoMoreInteractions(core_utilities.databaseStorage);
      }

      test('should return the requested user profile from the cache when loading the data was successful.', () async {
        // (A)rrange -> all necessary preconditions and inputs.
        cacheAnswerWhenReadAuthDataCalled(getDefaultIdentifier(), getDefaultUserProfileModel());

        // (A)ct -> on the object or method under test.
        Either<MyFailures, UserProfile> userProfileRepositoryResult = await callLoadAuthenticationData();

        // (A)ssert -> that the expected results have occurred.
        assert(userProfileRepositoryResult.isRight());
        await verifyRepositoryReadInteractionWithCache(getDefaultIdentifier());
      });

      test('should return a verification failure when loading the data from cache was not successful.', () async {
        // (A)rrange -> all necessary preconditions and inputs.
        DataEntryNotFoundException exception = const DataEntryNotFoundException();
        cacheThrowWhenReadAuthDataCalled(getDefaultIdentifier(), exception);

        // (A)ct -> on the object or method under test.
        Either<MyFailures, UserProfile> userProfileRepositoryResult = await callLoadAuthenticationData();

        // (A)ssert -> that the expected results have occurred.
        assert(userProfileRepositoryResult.isLeft());
        verifyFailureType(userProfileRepositoryResult, UserProfileVerificationFailure(exceptionCause: exception));
        verifyFailureDetails(userProfileRepositoryResult, exception);
        await verifyRepositoryReadInteractionWithCache(getDefaultIdentifier());
      });

      test('should return an access failure when loading the data from cache was not successful.', () async {
        // (A)rrange -> all necessary preconditions and inputs.
        CacheStorageReadException exception = const CacheStorageReadException();
        cacheThrowWhenReadAuthDataCalled(getDefaultIdentifier(), exception);

        // (A)ct -> on the object or method under test.
        Either<MyFailures, UserProfile> userProfileRepositoryResult = await callLoadAuthenticationData();

        // (A)ssert -> that the expected results have occurred.
        assert(userProfileRepositoryResult.isLeft());
        verifyFailureType(userProfileRepositoryResult, UserProfileAccessFailure(exceptionCause: exception));
        verifyFailureDetails(userProfileRepositoryResult, exception);
        await verifyRepositoryReadInteractionWithCache(getDefaultIdentifier());
      });
    });
  });

  group('Verify Store Authentication Data', () {
    Future<Either<MyFailures, UserProfile>> callStoreAuthenticationData() async {
      return await userProfileRepository.storeAuthData(
        identifier: getDefaultIdentifier(),
        passwordHash: getDefaultPasswordHash(),
      );
    }

    group('Check return values while network is online', () {
      setUp(() {
        whenGetNetworkConnectionStatusCalled(true);
      });

      void databaseAnswerWhenWriteAuthDataCalled(UserProfileModel userProfileModel) {
        when(core_utilities.databaseStorage.writeAuthData(userProfileModel: userProfileModel))
            .thenAnswer((_) async => NoParams());
      }

      void databaseThrowWhenWriteAuthDataCalled(UserProfileModel userProfileModel, MyExceptions returnValue) {
        when(core_utilities.databaseStorage.writeAuthData(userProfileModel: userProfileModel)).thenThrow(returnValue);
      }

      Future<void> verifyRepositoryWriteInteractionWithDatabase(UserProfileModel userProfileModel) async {
        verify(core_utilities.networkService.getConnectionStatus());
        assert(await core_utilities.networkService.getConnectionStatus() == true);
        verify(core_utilities.databaseStorage.writeAuthData(userProfileModel: userProfileModel));
        verifyNoMoreInteractions(core_utilities.cacheStorage);
        verifyNoMoreInteractions(core_utilities.databaseStorage);
      }

      test('should return a negligible parameter when storing into the database was successful.', () async {
        // (A)rrange -> all necessary preconditions and inputs.
        databaseAnswerWhenWriteAuthDataCalled(getDefaultUserProfileModel());

        // (A)ct -> on the object or method under test.
        Either<MyFailures, UserProfile> userProfileRepositoryResult = await callStoreAuthenticationData();

        // (A)ssert -> that the expected results have occurred.
        assert(userProfileRepositoryResult.isRight());
        verifyRepositoryWriteInteractionWithDatabase(getDefaultUserProfileModel());
      });

      test('should return an access failure when storing into the database was not successful.', () async {
        // (A)rrange -> all necessary preconditions and inputs.
        DatabaseStorageWriteException exception = const DatabaseStorageWriteException();
        databaseThrowWhenWriteAuthDataCalled(getDefaultUserProfileModel(), exception);

        // (A)ct -> on the object or method under test.
        Either<MyFailures, UserProfile> userProfileRepositoryResult = await callStoreAuthenticationData();

        // (A)ssert -> that the expected results have occurred.
        assert(userProfileRepositoryResult.isLeft());
        verifyFailureType(userProfileRepositoryResult, UserProfileAccessFailure(exceptionCause: exception));
        verifyFailureDetails(userProfileRepositoryResult, exception);
        verifyRepositoryWriteInteractionWithDatabase(getDefaultUserProfileModel());
      });
    });

    group('Check return values while network is offline', () {
      setUp(() {
        whenGetNetworkConnectionStatusCalled(false);
      });

      void cacheAnswerWhenWriteAuthDataCalled(UserProfileModel userProfileModel) {
        when(core_utilities.cacheStorage.writeAuthData(userProfileModel: userProfileModel)).thenAnswer((_) async => NoParams());
      }

      void cacheThrowWhenWriteAuthDataCalled(UserProfileModel userProfileModel, MyExceptions returnValue) {
        when(core_utilities.cacheStorage.writeAuthData(userProfileModel: userProfileModel)).thenThrow(returnValue);
      }

      Future<void> verifyRepositoryWriteInteractionWithCache(UserProfileModel userProfileModel) async {
        verify(core_utilities.networkService.getConnectionStatus());
        assert(await core_utilities.networkService.getConnectionStatus() == false);
        verify(core_utilities.cacheStorage.writeAuthData(userProfileModel: userProfileModel));
        verifyNoMoreInteractions(core_utilities.cacheStorage);
        verifyNoMoreInteractions(core_utilities.databaseStorage);
      }

      test('should return a negligible parameter when storing into the cache was successful.', () async {
        // (A)rrange -> all necessary preconditions and inputs.
        cacheAnswerWhenWriteAuthDataCalled(getDefaultUserProfileModel());

        // (A)ct -> on the object or method under test.
        Either<MyFailures, UserProfile> userProfileRepositoryResult = await callStoreAuthenticationData();

        // (A)ssert -> that the expected results have occurred.
        assert(userProfileRepositoryResult.isRight());
        await verifyRepositoryWriteInteractionWithCache(getDefaultUserProfileModel());
      });

      test('should return an access failure when storing into the cache was not successful.', () async {
        // (A)rrange -> all necessary preconditions and inputs.
        CacheStorageWriteException exception = const CacheStorageWriteException();
        cacheThrowWhenWriteAuthDataCalled(getDefaultUserProfileModel(), exception);

        // (A)ct -> on the object or method under test.
        Either<MyFailures, UserProfile> userProfileRepositoryResult = await callStoreAuthenticationData();

        // (A)ssert -> that the expected results have occurred.
        assert(userProfileRepositoryResult.isLeft());
        verifyFailureType(userProfileRepositoryResult, UserProfileAccessFailure(exceptionCause: exception));
        verifyFailureDetails(userProfileRepositoryResult, exception);
        await verifyRepositoryWriteInteractionWithCache(getDefaultUserProfileModel());
      });
    });
  });

  group('Verify Preload User Profile Data', () {
    Future<Either<MyFailures, NoParams>> callPreloadUserProfileData() async {
      return await userProfileRepository.preloadUserProfileData();
    }

    group('Check return values while network is online', () {
      setUp(() {
        whenGetNetworkConnectionStatusCalled(true);
      });

      Future<void> databaseRepositoryPreparationForPreloadCall(String identifier, UserProfileModel returnValue) async {
        when(core_utilities.databaseStorage.readAuthData(identifier: identifier)).thenAnswer((_) async => returnValue);
        await userProfileRepository.loadAuthData(identifier: identifier);
      }

      Future<void> verifyRepositoryDataPreloadInteractionWithDatabase() async {
        assert(await core_utilities.networkService.getConnectionStatus() == true);
        verify(core_utilities.networkService.getConnectionStatus());
        verifyNoMoreInteractions(core_utilities.networkService);
      }

      test('should return a negligible parameter when all user profile related data could successfully loaded from database.', () async {
        // (A)rrange -> all necessary preconditions and inputs.
        await databaseRepositoryPreparationForPreloadCall(getDefaultIdentifier(), getDefaultUserProfileModel());
        bool userProfileDataIsAvailable = false;
        getDefaultUserProfileModel().addListener(() {
          userProfileDataIsAvailable = !userProfileDataIsAvailable;
        });

        // (A)ct -> on the object or method under test.
        Either<MyFailures, NoParams> userProfileRepositoryResult = await callPreloadUserProfileData();

        // (A)ssert -> that the expected results have occurred.
        assert(userProfileRepositoryResult.isRight());
        expect(userProfileDataIsAvailable, true);
        await verifyRepositoryDataPreloadInteractionWithDatabase();
      });
    });

    group('Check return values while network is offline', () {
      setUp(() {
        whenGetNetworkConnectionStatusCalled(false);
      });

      Future<void> cacheRepositoryPreparationForPreloadCall(String identifier, UserProfileModel returnValue) async {
        when(core_utilities.cacheStorage.readAuthData(identifier: identifier)).thenAnswer((_) async => returnValue);
        await userProfileRepository.loadAuthData(identifier: identifier);
      }

      Future<void> verifyRepositoryDataPreloadInteractionWithCache() async {
        assert(await core_utilities.networkService.getConnectionStatus() == false);
        verify(core_utilities.networkService.getConnectionStatus());
        verifyNoMoreInteractions(core_utilities.networkService);
      }

      test('should return a negligible parameter when all user profile related data could successfully loaded from cache.', () async {
        // (A)rrange -> all necessary preconditions and inputs.
        await cacheRepositoryPreparationForPreloadCall(getDefaultIdentifier(), getDefaultUserProfileModel());
        bool userProfileDataIsAvailable = false;
        getDefaultUserProfileModel().addListener(() {
          userProfileDataIsAvailable = !userProfileDataIsAvailable;
        });

        // (A)ct -> on the object or method under test.
        Either<MyFailures, NoParams> userProfileRepositoryResult = await callPreloadUserProfileData();

        // (A)ssert -> that the expected results have occurred.
        assert(userProfileRepositoryResult.isRight());
        expect(userProfileDataIsAvailable, true);
        verifyRepositoryDataPreloadInteractionWithCache();
      });
    });
  });
}
