import 'package:u_auth/core/errors/exceptions/exceptions.dart';
import 'package:u_auth/core/errors/failures/failures.dart';
import 'package:u_auth/core/features/user_profile_authentication/domain/entities/user_profile.dart';
import 'package:u_auth/core/features/user_profile_authentication/domain/use_cases/verify_user_profile.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../../../test_utilities/fixtures/user_profile_fixtures.dart' as user_profile_fixtures;
import '../../../../../../test_utilities/mocks/repositories.dart' as repository_mocks;

/// Dart test cases for the [VerifyUserProfile] use case.
void main() {
  late VerifyUserProfile verifyUserProfile;

  setUp(() {
    verifyUserProfile = VerifyUserProfile(userProfileRepositoryContract: repository_mocks.userProfileRepositoryContract);
  });

  UserProfile getDefaultUserProfile() => user_profile_fixtures.defaultUserProfile;
  String getDefaultIdentifier() => user_profile_fixtures.defaultUserProfile.identifier;

  Map<String, String> getValidLoginCredentials() => {'identifier': getDefaultIdentifier(), 'password': "123"};
  Map<String, String> getInvalidLoginCredentials() => {'identifier': getDefaultIdentifier(), 'password': "abc"};

  MyFailures getInvalidPasswordVerificationFailure() =>
      UserProfileVerificationFailure(exceptionCause: InvalidPasswordException(identifier: getDefaultIdentifier()));
  MyFailures getEntryNotFoundVerificationFailure() =>
      const UserProfileVerificationFailure(exceptionCause: DataEntryNotFoundException());
  MyFailures getReadAccessFailure() => const UserProfileAccessFailure(exceptionCause: DatabaseStorageReadException());

  Either<MyFailures, UserProfile> getLoadAuthDataResultRight() => Right(getDefaultUserProfile());
  Either<MyFailures, UserProfile> getLoadAuthDataVerificationResultLeft() => Left(getEntryNotFoundVerificationFailure());
  Either<MyFailures, UserProfile> getLoadAuthDataAccessResultLeft() => Left(getReadAccessFailure());

  Future<Either<MyFailures, UserProfile>> callUseCaseVerifyUserProfile(Map<String, String> loginCredentials) async {
    return await verifyUserProfile(loginCredentials);
  }

  Either<MyFailures, UserProfile> getUserProfileVerificationResultLeft() => Left(getInvalidPasswordVerificationFailure());

  void repositoryAnswerWhenLoadAuthenticationDataCalled(String identifier, Either<MyFailures, UserProfile> returnValue) {
    when(repository_mocks.userProfileRepositoryContract.loadAuthData(identifier: identifier))
        .thenAnswer((_) async => returnValue);
  }

  void verifyRepositoryLoadAuthenticationDataCall(String identifier) {
    verify(repository_mocks.userProfileRepositoryContract.loadAuthData(identifier: identifier));
    verifyNoMoreInteractions(repository_mocks.userProfileRepositoryContract);
  }

  group('Verify return values of use case: VerifyUserProfile.', () {
    test('should return the corresponding user profile when the verification was successful.', () async {
      // (A)rrange -> all necessary preconditions and inputs.
      repositoryAnswerWhenLoadAuthenticationDataCalled(getDefaultIdentifier(), getLoadAuthDataResultRight());

      // (A)ct -> on the object or method under test.
      Either<MyFailures, UserProfile> verifyUserResult = await callUseCaseVerifyUserProfile(getValidLoginCredentials());

      // (A)ssert -> that the expected results have occurred.
      assert(verifyUserResult.isRight());
      expect(verifyUserResult, getLoadAuthDataResultRight());
      verifyRepositoryLoadAuthenticationDataCall(getValidLoginCredentials()['identifier']!);
    });

    test('should return a verification failure when the verification was not successful.', () async {
      // (A)rrange -> all necessary preconditions and inputs.
      repositoryAnswerWhenLoadAuthenticationDataCalled(getDefaultIdentifier(), getLoadAuthDataResultRight());

      // (A)ct -> on the object or method under test.
      Either<MyFailures, UserProfile> useCaseResult = await callUseCaseVerifyUserProfile(getInvalidLoginCredentials());

      // (A)ssert -> that the expected results have occurred.
      assert(useCaseResult.isLeft());
      expect(useCaseResult, getUserProfileVerificationResultLeft());
      verifyRepositoryLoadAuthenticationDataCall(getInvalidLoginCredentials()['identifier']!);
    });

    test('should return a verification failure when the data storage does not contain the requested entry.', () async {
      // (A)rrange -> all necessary preconditions and inputs.
      repositoryAnswerWhenLoadAuthenticationDataCalled(getDefaultIdentifier(), getLoadAuthDataVerificationResultLeft());

      // (A)ct -> on the object or method under test.
      Either<MyFailures, UserProfile> verifyUserResult = await callUseCaseVerifyUserProfile(getValidLoginCredentials());

      // (A)ssert -> that the expected results have occurred.
      assert(verifyUserResult.isLeft());
      expect(verifyUserResult, getLoadAuthDataVerificationResultLeft());
      verifyRepositoryLoadAuthenticationDataCall(getValidLoginCredentials()['identifier']!);
    });

    test('should return a access failure when the data storage read was not successful.', () async {
      // (A)rrange -> all necessary preconditions and inputs.
      repositoryAnswerWhenLoadAuthenticationDataCalled(getDefaultIdentifier(), getLoadAuthDataAccessResultLeft());

      // (A)ct -> on the object or method under test.
      Either<MyFailures, UserProfile> verifyUserResult = await callUseCaseVerifyUserProfile(getValidLoginCredentials());

      // (A)ssert -> that the expected results have occurred.
      assert(verifyUserResult.isLeft());
      expect(verifyUserResult, getLoadAuthDataAccessResultLeft());
      verifyRepositoryLoadAuthenticationDataCall(getInvalidLoginCredentials()['identifier']!);
    });
  });
}
