part of 'user_profile_authentication_bloc.dart';

/// Abstract class of [UserProfileAuthenticationBloc] relevant states.
abstract class UserProfileAuthenticationState extends Equatable {
  const UserProfileAuthenticationState();
}

/// State to define a failure during the access of an [UserProfile].
class UserProfileAuthenticationFailureState extends UserProfileAuthenticationState {
  final String failureMessage;

  const UserProfileAuthenticationFailureState({required this.failureMessage});

  @override
  List<Object> get props => [failureMessage, DateTime.now()]; // DateTime.now() is used due to the possible repeated occurrences of the event.
}

/// State to define the availability of an [UserProfile].
class UserProfileNotAuthenticatedState extends UserProfileAuthenticationState {
  const UserProfileNotAuthenticatedState();

  @override
  List<Object> get props => [];
}

/// State to define the loading of an [UserProfile].
class UserProfileLoginInProgressState extends UserProfileAuthenticationState {
  const UserProfileLoginInProgressState();

  @override
  List<Object> get props => [];
}

/// State to define the verification of login credentials during a login attempt.
class UserProfileLoginVerificationInProgressState extends UserProfileAuthenticationState {
  const UserProfileLoginVerificationInProgressState();

  @override
  List<Object> get props => [];
}

/// State to define the verification of login credentials during a registration attempt.
class UserProfileRegistrationVerificationInProgressState extends UserProfileAuthenticationState {
  const UserProfileRegistrationVerificationInProgressState();

  @override
  List<Object> get props => [];
}

/// State to define the registration of an [UserProfile].
class UserProfileRegistrationInProgressState extends UserProfileAuthenticationState {
  final String identifier;
  final String password;

  const UserProfileRegistrationInProgressState({required this.identifier, required this.password});

  @override
  List<Object> get props => [identifier, password];
}

/// State to define the sign in of an [UserProfile].
class UserProfileSignInInProgressState extends UserProfileAuthenticationState {
  const UserProfileSignInInProgressState();

  @override
  List<Object> get props => [];
}

/// State to define the logout of an [UserProfile].
class UserProfileLogoutInProgressState extends UserProfileAuthenticationState {
  const UserProfileLogoutInProgressState();

  @override
  List<Object> get props => [];
}

/// State to define the availability of an [UserProfile].
class UserProfileAuthenticatedState extends UserProfileAuthenticationState {
  const UserProfileAuthenticatedState();

  @override
  List<Object> get props => [];
}
