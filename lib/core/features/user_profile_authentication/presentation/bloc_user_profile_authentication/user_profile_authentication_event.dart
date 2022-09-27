part of 'user_profile_authentication_bloc.dart';

/// Abstract class of [UserProfileAuthenticationBloc] relevant events.
abstract class UserProfileAuthenticationEvent extends Equatable {
  const UserProfileAuthenticationEvent();
}

/// Event to notify the application about a login attempt for a specific [UserProfile].
class UserProfileLoginEvent extends UserProfileAuthenticationEvent {
  final String identifier;
  final String password;

  const UserProfileLoginEvent({required this.identifier, required this.password});

  @override
  List<Object> get props => [identifier, password];
}

/// Event to notify the application about an logout attempt for the current [UserProfile].
class UserProfileLogoutEvent extends UserProfileAuthenticationEvent {
  const UserProfileLogoutEvent();

  @override
  List<Object> get props => [];
}

/// Event to notify the application about an attempt to register a new [UserProfile].
class UserProfileRegistrationEvent extends UserProfileAuthenticationEvent {
  final String identifier;
  final String password;

  const UserProfileRegistrationEvent({required this.identifier, required this.password});

  @override
  List<Object> get props => [identifier, password];
}

/// Event to notify the application about an abort of the current registration of a new [UserProfile].
class UserProfileAbortRegistrationEvent extends UserProfileAuthenticationEvent {
  const UserProfileAbortRegistrationEvent();

  @override
  List<Object> get props => [];
}

/// Event to notify the application about an attempt to complete the registration of a new [UserProfile].
class UserProfileSignInEvent extends UserProfileAuthenticationEvent {
  final String identifier;
  final String password;
  final String firstName;
  final String lastName;
  final String eMail;

  const UserProfileSignInEvent(
      {required this.identifier,
        required this.password,
        required this.firstName,
        required this.lastName,
        required this.eMail});

  @override
  List<Object> get props => [identifier, password, firstName, lastName, eMail];
}
