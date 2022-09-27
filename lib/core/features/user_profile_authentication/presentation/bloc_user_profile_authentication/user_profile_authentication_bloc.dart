import 'package:u_auth/core/errors/exceptions/exceptions.dart';
import 'package:u_auth/core/errors/failures/failures.dart';
import 'package:u_auth/core/features/user_profile_authentication/domain/entities/user_profile.dart';
import 'package:u_auth/core/features/user_profile_authentication/domain/use_cases/login_user_profile.dart';
import 'package:u_auth/core/features/user_profile_authentication/domain/use_cases/register_user_profile.dart';
import 'package:u_auth/core/features/user_profile_authentication/domain/use_cases/verify_user_profile.dart';
import 'package:u_auth/core/utilities/constants.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_profile_authentication_event.dart';

part 'user_profile_authentication_state.dart';

class UserProfileAuthenticationBloc extends Bloc<UserProfileAuthenticationEvent, UserProfileAuthenticationState> {
  final VerifyUserProfile useCaseVerifyUserProfile;
  final RegisterUserProfile useCaseRegisterUserProfile;
  final LoginUserProfile useCaseLoginUserProfile;

  UserProfileAuthenticationBloc({
    required this.useCaseVerifyUserProfile,
    required this.useCaseRegisterUserProfile,
    required this.useCaseLoginUserProfile,
  }) : super(const UserProfileNotAuthenticatedState()) {
    on<UserProfileAuthenticationEvent>((event, emit) async {
      if (event is UserProfileLoginEvent) {
        emit(const UserProfileLoginVerificationInProgressState());
        try {
          UserProfile userProfile = await callUserProfileLoginVerificationUseCase(event.identifier, event.password);
          emit(const UserProfileLoginInProgressState());
          userProfile.addListener(() {
            emit(const UserProfileAuthenticatedState());
          });
          await callUserProfileLoginUseCase();
        } on UserProfileAuthenticationFailureState catch (failure) {
          emit(UserProfileAuthenticationFailureState(failureMessage: failure.failureMessage));
        }
      } else if (event is UserProfileLogoutEvent) {
        emit(const UserProfileLogoutInProgressState());
        await Future.delayed(const Duration(milliseconds: 250)).then((_) {
          emit(const UserProfileNotAuthenticatedState());
        });
      } else if (event is UserProfileRegistrationEvent) {
        emit(const UserProfileRegistrationVerificationInProgressState());
        try {
          await callUserProfileRegistrationVerificationUseCase(event.identifier, event.password);
          emit(UserProfileRegistrationInProgressState(identifier: event.identifier, password: event.password));
        } on UserProfileAuthenticationFailureState catch (failure) {
          emit(UserProfileAuthenticationFailureState(failureMessage: failure.failureMessage));
        }
      } else if (event is UserProfileAbortRegistrationEvent) {
        emit(const UserProfileNotAuthenticatedState());
      } else if (event is UserProfileSignInEvent) {
        emit(const UserProfileSignInInProgressState());
        try {
          UserProfile userProfile = await callUserProfileSignInUseCase(
              event.identifier, event.password, event.firstName, event.lastName, event.eMail);
          userProfile.addListener(() {
            emit(const UserProfileAuthenticatedState());
          });
          await callUserProfileLoginUseCase();
        } on UserProfileAuthenticationFailureState catch (failure) {
          emit(UserProfileAuthenticationFailureState(failureMessage: failure.failureMessage));
        }
      }
    });
  }

  Future<UserProfile> callUserProfileLoginVerificationUseCase(String identifier, String password) async {
    return (await useCaseVerifyUserProfile({"identifier": identifier, "password": password})).fold((failure) {
      throw UserProfileAuthenticationFailureState(failureMessage: failure.failureMessage);
    }, (userProfile) {
      return userProfile;
    });
  }

  Future<void> callUserProfileRegistrationVerificationUseCase(String identifier, String password) async {
    String registrationFailureMessage = "User login $identifier already exist!";
    (await useCaseVerifyUserProfile({"identifier": identifier, "password": password})).fold((failure) {
      if (failure is UserProfileVerificationFailure) {
        if (failure.exceptionCause is! DataEntryNotFoundException) {
          throw (UserProfileAuthenticationFailureState(failureMessage: registrationFailureMessage));
        }
      } else {
        throw (UserProfileAuthenticationFailureState(failureMessage: failure.failureMessage));
      }
    }, (userProfile) {
      throw (UserProfileAuthenticationFailureState(failureMessage: registrationFailureMessage));
    });
  }

  Future<void> callUserProfileLoginUseCase() async {
    (await useCaseLoginUserProfile(NoParams())).fold((failure) {
      throw UserProfileAuthenticationFailureState(failureMessage: failure.failureMessage);
    }, (noParams) {});
  }

  Future<UserProfile> callUserProfileSignInUseCase(identifier, password, firstName, lastName, eMail) async {
    return (await useCaseRegisterUserProfile({
      "identifier": identifier,
      "password": password,
      "firstName": firstName,
      "lastName": lastName,
      "eMail": eMail,
    }))
        .fold((failure) {
      throw (UserProfileAuthenticationFailureState(failureMessage: failure.failureMessage));
    }, (userProfile) async {
      return userProfile;
    });
  }
}
