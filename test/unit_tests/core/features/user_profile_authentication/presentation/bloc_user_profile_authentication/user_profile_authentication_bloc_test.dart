import 'package:u_auth/core/errors/exceptions/exceptions.dart';
import 'package:u_auth/core/errors/failures/failures.dart';
import 'package:u_auth/core/features/user_profile_authentication/domain/entities/user_profile.dart';
import 'package:u_auth/core/features/user_profile_authentication/presentation/bloc_user_profile_authentication/user_profile_authentication_bloc.dart';
import 'package:u_auth/core/utilities/constants.dart';
import 'package:u_auth/core/utilities/constants.dart' as constants;
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../../../test_utilities/fixtures/user_profile_fixtures.dart' as user_profile_fixtures;
import '../../../../../../test_utilities/mocks/use_cases.dart' as use_cases_mocks;

/// Dart test cases for the [UserProfileAuthenticationBloc].
void main() {
  late UserProfileAuthenticationBloc userProfileAuthenticationBloc;

  setUp(() {
    userProfileAuthenticationBloc = UserProfileAuthenticationBloc(
      useCaseVerifyUserProfile: use_cases_mocks.verifyUserProfile,
      useCaseRegisterUserProfile: use_cases_mocks.registerUserProfile,
      useCaseLoginUserProfile: use_cases_mocks.loginUserProfile,
    );
  });

  UserProfile getDefaultUserProfile() => user_profile_fixtures.defaultUserProfile;
  String getDefaultIdentifier() => getDefaultUserProfile().identifier;
  String getDefaultPassword() => "123";
  Map<String, String> getDefaultLoginCredentials() => {'identifier': getDefaultIdentifier(), 'password': getDefaultPassword()};
  Map<String, String> getDefaultUserCredentials() => {
        "identifier": getDefaultIdentifier(),
        "password": "123",
        "firstName": "John",
        "lastName": "Doe",
        "eMail": "john@doe.de",
      };

  MyFailures getVerificationFailure() => const UserProfileVerificationFailure(exceptionCause: DataEntryNotFoundException());
  MyFailures getReadAccessFailure() => const UserProfileAccessFailure(exceptionCause: CacheStorageReadException());
  MyFailures getWriteAccessFailure() => const UserProfileAccessFailure(exceptionCause: CacheStorageWriteException());

  Right<MyFailures, UserProfile> getVerifyUserProfileEitherRight() => Right(getDefaultUserProfile());
  Left<MyFailures, UserProfile> getVerifyUserProfileEitherLeft() => Left(getVerificationFailure());

  Right<MyFailures, NoParams> getLoginUserProfileEitherRight() => Right(NoParams());
  Left<MyFailures, NoParams> getLoginUserProfileEitherLeft() => Left(getReadAccessFailure());

  void useCaseAnswerWhenVerifyUserProfileCalled(Either<MyFailures, UserProfile> returnValue) {
    when(use_cases_mocks.verifyUserProfile(getDefaultLoginCredentials())).thenAnswer((_) async => returnValue);
  }

  void updateDefaultUserProfileDataState(constants.UserProfileDataState userProfileDataState) {
    getDefaultUserProfile().updateDataAvailability(userProfileDataState);
  }

  void useCaseAnswerWhenLoginUserProfileCalled() {
    when(use_cases_mocks.loginUserProfile(NoParams())).thenAnswer((_) async {
      return getLoginUserProfileEitherRight();
    });
  }

  void useCaseAnswerWhenLoginUserProfileSuccessfullyCalled() {
    when(use_cases_mocks.loginUserProfile(NoParams())).thenAnswer((_) async {
      updateDefaultUserProfileDataState(constants.UserProfileDataState.isAvailable);
      return getLoginUserProfileEitherRight();
    });
  }

  void useCaseAnswerWhenLoginUserProfileUnsuccessfullyCalled() {
    when(use_cases_mocks.loginUserProfile(NoParams())).thenAnswer((_) async {
      return getLoginUserProfileEitherLeft();
    });
  }

  test('should emit initially the user profile not authenticated state when created.', () async {
    // (A)ssert -> that the expected results have occurred.
    expect(userProfileAuthenticationBloc.state, const UserProfileNotAuthenticatedState());
  });

  group('BLoC Event: User Profile Login.', () {
    void addUserProfileLoginBlocEvent() {
      userProfileAuthenticationBloc.add(UserProfileLoginEvent(
        identifier: getDefaultLoginCredentials()['identifier']!,
        password: getDefaultLoginCredentials()['password']!,
      ));
    }

    group('Use Case verification during user profile login.', () {
      test('should call the verify user profile use case when a login attempt occur.', () async {
        // (A)rrange -> all necessary preconditions and inputs.
        useCaseAnswerWhenVerifyUserProfileCalled(getVerifyUserProfileEitherRight());
        useCaseAnswerWhenLoginUserProfileSuccessfullyCalled();

        // (A)ct -> on the object or method under test.
        addUserProfileLoginBlocEvent();
        await untilCalled(use_cases_mocks.verifyUserProfile(getDefaultLoginCredentials()));

        // (A)ssert -> that the expected results have occurred.
        verify(use_cases_mocks.verifyUserProfile(getDefaultLoginCredentials()));
      });

      test('should call the login user profile use case when a login attempt occur.', () async {
        // (A)rrange -> all necessary preconditions and inputs.
        useCaseAnswerWhenVerifyUserProfileCalled(getVerifyUserProfileEitherRight());
        useCaseAnswerWhenLoginUserProfileCalled();

        // (A)ct -> on the object or method under test.
        addUserProfileLoginBlocEvent();
        await untilCalled(use_cases_mocks.loginUserProfile(NoParams()));

        // (A)ssert -> that the expected results have occurred.
        verify(use_cases_mocks.loginUserProfile(NoParams()));
      });
    });

    group('State verification during user profile login.', () {
      test('should emit an login verification in progress state when a login attempt occur.', () async {
        // (A)rrange -> all necessary preconditions and inputs.
        useCaseAnswerWhenVerifyUserProfileCalled(getVerifyUserProfileEitherRight());
        useCaseAnswerWhenLoginUserProfileCalled();

        // (A)ssert Later -> that the predefined state order has occurred.
        final List<UserProfileAuthenticationState> expectedStates = [
          const UserProfileLoginVerificationInProgressState(),
        ];
        expectLater(userProfileAuthenticationBloc.stream, emitsInOrder(expectedStates));

        // (A)ct -> on the object or method under test.
        addUserProfileLoginBlocEvent();
      });

      test('should emit an user profile login in progress state when the verification was successful.', () async {
        // (A)rrange -> all necessary preconditions and inputs.
        useCaseAnswerWhenVerifyUserProfileCalled(getVerifyUserProfileEitherRight());
        useCaseAnswerWhenLoginUserProfileCalled();

        // (A)ssert Later -> that the predefined state order has occurred.
        final List<UserProfileAuthenticationState> expectedStates = [
          const UserProfileLoginVerificationInProgressState(),
          const UserProfileLoginInProgressState(),
        ];
        expectLater(userProfileAuthenticationBloc.stream, emitsInOrder(expectedStates));

        // (A)ct -> on the object or method under test.
        addUserProfileLoginBlocEvent();
      });

      test('should emit an authentication failure state when the verification was not successful.', () async {
        // (A)rrange -> all necessary preconditions and inputs.
        useCaseAnswerWhenVerifyUserProfileCalled(getVerifyUserProfileEitherLeft());

        // (A)ssert Later -> that the predefined state order has occurred.
        final List<UserProfileAuthenticationState> expectedStates = [
          const UserProfileLoginVerificationInProgressState(),
          UserProfileAuthenticationFailureState(failureMessage: getVerificationFailure().failureMessage),
        ];
        expectLater(userProfileAuthenticationBloc.stream, emitsInOrder(expectedStates));

        // (A)ct -> on the object or method under test.
        addUserProfileLoginBlocEvent();
      });

      test('should emit an user profile authenticated state when the login was successful.', () async {
        // (A)rrange -> all necessary preconditions and inputs.
        useCaseAnswerWhenVerifyUserProfileCalled(getVerifyUserProfileEitherRight());
        useCaseAnswerWhenLoginUserProfileSuccessfullyCalled();

        // (A)ssert Later -> that the predefined state order has occurred.
        final List<UserProfileAuthenticationState> expectedStates = [
          const UserProfileLoginVerificationInProgressState(),
          const UserProfileLoginInProgressState(),
          const UserProfileAuthenticatedState(),
        ];
        expectLater(userProfileAuthenticationBloc.stream, emitsInOrder(expectedStates));

        // (A)ct -> on the object or method under test.
        addUserProfileLoginBlocEvent();
      });

      test('should emit an authentication failure state when the user data after a login could not be loaded.', () async {
        // (A)rrange -> all necessary preconditions and inputs.
        useCaseAnswerWhenVerifyUserProfileCalled(getVerifyUserProfileEitherRight());
        useCaseAnswerWhenLoginUserProfileUnsuccessfullyCalled();

        // (A)ssert Later -> that the predefined state order has occurred.
        final List<UserProfileAuthenticationState> expectedStates = [
          const UserProfileLoginVerificationInProgressState(),
          const UserProfileLoginInProgressState(),
          UserProfileAuthenticationFailureState(failureMessage: getReadAccessFailure().failureMessage),
        ];
        expectLater(userProfileAuthenticationBloc.stream, emitsInOrder(expectedStates));

        // (A)ct -> on the object or method under test.
        addUserProfileLoginBlocEvent();
      });
    });
  });

  group('BLoC Event: User Profile Registration.', () {
    void addRUserProfileRegistrationBlocEvent() {
      userProfileAuthenticationBloc.add(UserProfileRegistrationEvent(
        identifier: getDefaultLoginCredentials()['identifier']!,
        password: getDefaultLoginCredentials()['password']!,
      ));
    }

    test('should call the verify user profile use case when a registration attempt occur.', () async {
      // (A)rrange -> all necessary preconditions and inputs.
      useCaseAnswerWhenVerifyUserProfileCalled(getVerifyUserProfileEitherRight());

      // (A)ct -> on the object or method under test.
      addRUserProfileRegistrationBlocEvent();
      await untilCalled(use_cases_mocks.verifyUserProfile(getDefaultLoginCredentials()));

      // (A)ssert -> that the expected results have occurred.
      verify(use_cases_mocks.verifyUserProfile(getDefaultLoginCredentials()));
    });

    group('State verification during user profile registration.', () {
      test('should emit an registration verification in progress state when a registration attempt occur.', () async {
        // (A)rrange -> all necessary preconditions and inputs.
        useCaseAnswerWhenVerifyUserProfileCalled(getVerifyUserProfileEitherRight());

        // (A)ssert Later -> that the predefined state order has occurred.
        final List<UserProfileAuthenticationState> expectedStates = [
          const UserProfileRegistrationVerificationInProgressState(),
        ];
        expectLater(userProfileAuthenticationBloc.stream, emitsInOrder(expectedStates));

        // (A)ct -> on the object or method under test.
        addRUserProfileRegistrationBlocEvent();
      });

      test('should emit an user profile registration in progress state when the user profile not already exist.', () async {
        // (A)rrange -> all necessary preconditions and inputs.
        useCaseAnswerWhenVerifyUserProfileCalled(getVerifyUserProfileEitherLeft());

        // (A)ssert Later -> that the predefined state order has occurred.
        final List<UserProfileAuthenticationState> expectedStates = [
          const UserProfileRegistrationVerificationInProgressState(),
          UserProfileRegistrationInProgressState(identifier: getDefaultIdentifier(), password: getDefaultPassword()),
        ];
        expectLater(userProfileAuthenticationBloc.stream, emitsInOrder(expectedStates));

        // (A)ct -> on the object or method under test.
        addRUserProfileRegistrationBlocEvent();
      });

      test('should emit an user profile authentication failure state when the user profile already exist.', () async {
        // (A)rrange -> all necessary preconditions and inputs.
        useCaseAnswerWhenVerifyUserProfileCalled(getVerifyUserProfileEitherRight());

        // (A)ssert Later -> that the predefined state order has occurred.
        final List<UserProfileAuthenticationState> expectedStates = [
          const UserProfileRegistrationVerificationInProgressState(),
          UserProfileAuthenticationFailureState(failureMessage: "User login ${getDefaultIdentifier()} already exist!"),
        ];
        expectLater(userProfileAuthenticationBloc.stream, emitsInOrder(expectedStates));

        // (A)ct -> on the object or method under test.
        addRUserProfileRegistrationBlocEvent();
      });
    });
  });

  group('BLoC Event: User Profile Abort Registration.', () {
    void addRUserProfileAbortRegistrationBlocEvent() {
      userProfileAuthenticationBloc.add(const UserProfileAbortRegistrationEvent());
    }

    test('should emit an user profile not authenticated state when the registration was aborted.', () async {
      // (A)rrange -> all necessary preconditions and inputs.
      useCaseAnswerWhenVerifyUserProfileCalled(getVerifyUserProfileEitherLeft());
      userProfileAuthenticationBloc.add(UserProfileRegistrationEvent(
        identifier: getDefaultLoginCredentials()['identifier']!,
        password: getDefaultLoginCredentials()['password']!,
      ));

      // (A)ssert Later -> that the predefined state order has occurred.
      final List<UserProfileAuthenticationState> expectedStates = [
        const UserProfileRegistrationVerificationInProgressState(),
        UserProfileRegistrationInProgressState(identifier: getDefaultIdentifier(), password: getDefaultPassword()),
        const UserProfileNotAuthenticatedState(),
      ];
      expectLater(userProfileAuthenticationBloc.stream, emitsInOrder(expectedStates));

      // (A)ct -> on the object or method under test.
      addRUserProfileAbortRegistrationBlocEvent();
    });
  });

  group('BLoC Event: User Profile Sign In.', () {
    void addRUserProfileSignInBlocEvent() {
      userProfileAuthenticationBloc.add(UserProfileSignInEvent(
        identifier: getDefaultUserCredentials()['identifier']!,
        password: getDefaultUserCredentials()['password']!,
        firstName: getDefaultUserCredentials()['firstName']!,
        lastName: getDefaultUserCredentials()['lastName']!,
        eMail: getDefaultUserCredentials()['eMail']!,
      ));
    }

    void useCaseAnswerWhenRegisterUserProfileCalled(Either<MyFailures, UserProfile> returnValue) {
      when(use_cases_mocks.registerUserProfile(getDefaultUserCredentials())).thenAnswer((_) async => returnValue);
    }

    Right<MyFailures, UserProfile> getRegisterUserProfileEitherRight() => Right(getDefaultUserProfile());
    Left<MyFailures, UserProfile> getRegisterUserProfileEitherLeft() => Left(getWriteAccessFailure());

    group('Use Case verification during user profile sign in.', () {
      test('should call the register user use case when a sign in attempt occur.', () async {
        // (A)rrange -> all necessary preconditions and inputs.
        useCaseAnswerWhenRegisterUserProfileCalled(getRegisterUserProfileEitherRight());
        useCaseAnswerWhenLoginUserProfileCalled();

        // (A)ct -> on the object or method under test.
        addRUserProfileSignInBlocEvent();
        await untilCalled(use_cases_mocks.loginUserProfile(NoParams()));

        // (A)ssert -> that the expected results have occurred.
        verify(use_cases_mocks.registerUserProfile(getDefaultUserCredentials()));
      });

      test('should call the login user profile use case when a sign in attempt occur.', () async {
        // (A)rrange -> all necessary preconditions and inputs.
        useCaseAnswerWhenRegisterUserProfileCalled(getRegisterUserProfileEitherRight());
        useCaseAnswerWhenLoginUserProfileCalled();

        // (A)ct -> on the object or method under test.
        addRUserProfileSignInBlocEvent();
        await untilCalled(use_cases_mocks.loginUserProfile(NoParams()));

        // (A)ssert -> that the expected results have occurred.
        verify(use_cases_mocks.loginUserProfile(NoParams()));
      });
    });

    group('State verification during user profile sign in.', () {
      test('should emit an user profile sign in in progress state when a sign in attempt occur.', () async {
        // (A)rrange -> all necessary preconditions and inputs.
        useCaseAnswerWhenRegisterUserProfileCalled(getRegisterUserProfileEitherRight());
        useCaseAnswerWhenLoginUserProfileCalled();

        // (A)ssert Later -> that the predefined state order has occurred.
        final List<UserProfileAuthenticationState> expectedStates = [
          const UserProfileSignInInProgressState(),
        ];
        expectLater(userProfileAuthenticationBloc.stream, emitsInOrder(expectedStates));

        // (A)ct -> on the object or method under test.
        addRUserProfileSignInBlocEvent();
      });

      test('should emit an user profile authentication failure state when the registration was not successful.', () async {
        // (A)rrange -> all necessary preconditions and inputs.
        useCaseAnswerWhenRegisterUserProfileCalled(getRegisterUserProfileEitherLeft());

        // (A)ssert Later -> that the predefined state order has occurred.
        List<UserProfileAuthenticationState> expectedResults = [
          const UserProfileSignInInProgressState(),
          UserProfileAuthenticationFailureState(failureMessage: getWriteAccessFailure().failureMessage),
        ];
        expectLater(userProfileAuthenticationBloc.stream, emitsInOrder(expectedResults));

        // (A)ct -> on the object or method under test.
        addRUserProfileSignInBlocEvent();
      });

      test('should emit an user profile authenticated state when the login after a registration was successful.', () async {
        // (A)rrange -> all necessary preconditions and inputs.
        useCaseAnswerWhenRegisterUserProfileCalled(getRegisterUserProfileEitherRight());
        useCaseAnswerWhenLoginUserProfileSuccessfullyCalled();

        // (A)ssert Later -> that the predefined state order has occurred.
        final List<UserProfileAuthenticationState> expectedStates = [
          const UserProfileSignInInProgressState(),
          const UserProfileAuthenticatedState(),
        ];
        expectLater(userProfileAuthenticationBloc.stream, emitsInOrder(expectedStates));

        // (A)ct -> on the object or method under test.
        addRUserProfileSignInBlocEvent();
      });

      test('should emit an authentication failure state when the user data after a sign in could not be loaded.', () async {
        // (A)rrange -> all necessary preconditions and inputs.
        useCaseAnswerWhenRegisterUserProfileCalled(getRegisterUserProfileEitherRight());
        useCaseAnswerWhenLoginUserProfileUnsuccessfullyCalled();

        // (A)ssert Later -> that the predefined state order has occurred.
        final List<UserProfileAuthenticationState> expectedStates = [
          const UserProfileSignInInProgressState(),
          UserProfileAuthenticationFailureState(failureMessage: getReadAccessFailure().failureMessage),
        ];
        expectLater(userProfileAuthenticationBloc.stream, emitsInOrder(expectedStates));

        // (A)ct -> on the object or method under test.
        addRUserProfileSignInBlocEvent();
      });
    });
  });

  group('BLoC Event: User Profile Logout.', () {
      test('should emit an user profile not authenticated state when a logout attempt occur.', () async {
        // (A)ssert Later -> that the predefined state order has occurred.
        final expectedStates = [
          const UserProfileLogoutInProgressState(),
          const UserProfileNotAuthenticatedState(),
        ];
        expectLater(userProfileAuthenticationBloc.stream, emitsInOrder(expectedStates));

        // (A)ct -> on the object or method under test.
        userProfileAuthenticationBloc.add(const UserProfileLogoutEvent());
      });

});
}
