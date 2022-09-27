import 'package:u_auth/core/errors/exceptions/exceptions.dart';
import 'package:u_auth/core/errors/failures/failures.dart';
import 'package:u_auth/core/features/user_profile_authentication/domain/entities/user_profile.dart';
import 'package:u_auth/core/features/user_profile_authentication/domain/use_cases/register_user_profile.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../../../test_utilities/fixtures/user_profile_fixtures.dart' as user_profile_fixtures;
import '../../../../../../test_utilities/mocks/repositories.dart' as repository_mocks;

/// Dart test cases for the [RegisterUserProfile] use case.
void main() {
  late RegisterUserProfile registerUserProfile;

  setUp(() {
    registerUserProfile = RegisterUserProfile(userProfileRepositoryContract: repository_mocks.userProfileRepositoryContract);
  });

  UserProfile getDefaultUserProfile() => user_profile_fixtures.defaultUserProfile;
  String getDefaultIdentifier() => getDefaultUserProfile().identifier;
  String getDefaultPasswordHash() => getDefaultUserProfile().passwordHash;

  Map<String, String> getUserCredentials() => {
        'identifier': getDefaultIdentifier(),
        'password': "123",
      };
  Map<String, String> getEncryptedUserCredentials() => {
        'identifier': getDefaultIdentifier(),
        'passwordHash': getDefaultPasswordHash(),
      };

  Future<Either<MyFailures, UserProfile>> callUseCaseRegistrationUserProfile() async {
    return await registerUserProfile(getUserCredentials());
  }

  void repoAnswerWhenStoreAuthDataCalled(Map<String, String> userCredentials, Either<MyFailures, UserProfile> returnValue) {
    when(repository_mocks.userProfileRepositoryContract.storeAuthData(
      identifier: userCredentials['identifier'],
      passwordHash: userCredentials['passwordHash'],
    )).thenAnswer((_) async => returnValue);
  }

  void verifyRepositoryStoreAuthenticationDataCall(Map<String, String> userCredentials) {
    verify(repository_mocks.userProfileRepositoryContract.storeAuthData(
      identifier: userCredentials['identifier'],
      passwordHash: userCredentials['passwordHash'],
    ));
    verifyNoMoreInteractions(repository_mocks.userProfileRepositoryContract);
  }

  group('Verify return values of use case: RegisterUserProfile.', () {
    test('should return the corresponding user profile when the registration was successful.', () async {
      // (A)rrange -> all necessary preconditions and inputs.
      Either<MyFailures, UserProfile> storeAuthResult = Right(getDefaultUserProfile());
      repoAnswerWhenStoreAuthDataCalled(getEncryptedUserCredentials(), storeAuthResult);

      // (A)ct -> on the object or method under test.
      Either<MyFailures, UserProfile> registerResult = await callUseCaseRegistrationUserProfile();

      // (A)ssert -> that the expected results have occurred.
      assert(registerResult.isRight());
      expect(registerResult, storeAuthResult);
      verifyRepositoryStoreAuthenticationDataCall(getEncryptedUserCredentials());
    });

    test('should return an access failure when the registration was not successful.', () async {
      // (A)rrange -> all necessary preconditions and inputs.
      MyFailures accessFailure = const UserProfileAccessFailure(exceptionCause: CacheStorageReadException());
      Either<MyFailures, UserProfile> storeAuthResult = Left(accessFailure);
      repoAnswerWhenStoreAuthDataCalled(getEncryptedUserCredentials(), storeAuthResult);

      // (A)ct -> on the object or method under test.
      Either<MyFailures, UserProfile> registerResult = await callUseCaseRegistrationUserProfile();

      // (A)ssert -> that the expected results have occurred.
      assert(registerResult.isLeft());
      expect(registerResult, storeAuthResult);
      verifyRepositoryStoreAuthenticationDataCall(getEncryptedUserCredentials());
    });
  });
}
