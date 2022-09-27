import 'package:u_auth/core/errors/exceptions/exceptions.dart';
import 'package:u_auth/core/errors/failures/failures.dart';
import 'package:u_auth/core/features/user_profile_authentication/domain/use_cases/login_user_profile.dart';
import 'package:u_auth/core/utilities/constants.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../../../test_utilities/mocks/repositories.dart' as repository_mocks;

/// Dart test cases for the [LoginUser] use case.
void main() {
  late LoginUserProfile loginUserProfile;

  setUp(() {
    loginUserProfile = LoginUserProfile(userProfileRepositoryContract: repository_mocks.userProfileRepositoryContract);
  });

  Future<Either<MyFailures, NoParams>> callUseCaseLoginUserProfile() async {
    return await loginUserProfile(NoParams());
  }

  void repositoryAnswerWhenPreloadUserProfileDataCalled(Either<MyFailures, NoParams> returnValue) {
    when(repository_mocks.userProfileRepositoryContract.preloadUserProfileData()).thenAnswer((_) async => returnValue);
  }

  void verifyRepositoryPreloadUserProfileDataCall() {
    verify(repository_mocks.userProfileRepositoryContract.preloadUserProfileData());
    verifyNoMoreInteractions(repository_mocks.userProfileRepositoryContract);
  }

  group('Verify return values of use case: LoginUserProfile.', () {
    test('should return a negligible parameter when login was successful.', () async {
      // (A)rrange -> all necessary preconditions and inputs.
      Either<MyFailures, NoParams> preloadUserProfileDataResult = Right(NoParams());
      repositoryAnswerWhenPreloadUserProfileDataCalled(preloadUserProfileDataResult);

      // (A)ct -> on the object or method under test.
      Either<MyFailures, NoParams> loginUserResult = await callUseCaseLoginUserProfile();

      // (A)ssert -> that the expected results have occurred.
      assert(loginUserResult.isRight());
      expect(loginUserResult, preloadUserProfileDataResult);
      verifyRepositoryPreloadUserProfileDataCall();
    });

    test('should return an access failure when login was not successful.', () async {
      // (A)rrange -> all necessary preconditions and inputs.
      MyFailures accessFailure = const UserProfileAccessFailure(exceptionCause: CacheStorageReadException());
      Either<MyFailures, NoParams> preloadUserProfileDataResult = Left(accessFailure);
      repositoryAnswerWhenPreloadUserProfileDataCalled(preloadUserProfileDataResult);

      // (A)ct -> on the object or method under test.
      Either<MyFailures, NoParams> loginUserResult = await callUseCaseLoginUserProfile();

      // (A)ssert -> that the expected results have occurred.
      assert(loginUserResult.isLeft());
      expect(loginUserResult, preloadUserProfileDataResult);
      verifyRepositoryPreloadUserProfileDataCall();
    });
  });
}
