import 'package:u_auth/core/features/user_profile_authentication/presentation/bloc_user_profile_authentication/user_profile_authentication_bloc.dart';
import 'package:u_auth/core/utilities/ui_properties.dart' as ui_properties;
import 'package:flutter/material.dart';

/// This widget represents the button template of the [UserProfileAuthentication] button widgets.
///{@Category Widgets}
class UserProfileAuthenticationButton extends StatefulWidget {
  /// The text of the actual button
  final String buttonText;

  /// The specific event for the user profile authentication, depending on the actual button.
  final Type event;

  /// The current state of the user profile authentication, relevant for the button representation.
  final UserProfileAuthenticationState state;

  /// Function callback for the onPressed method of the actual button.
  final Function()? onPressed;

  /// Creates a configurable button for [UserProfileAuthentication] related widgets.
  ///
  /// Requires the displayed [buttonText], visible for the user.
  /// The current [state] and [event] of the [UserProfileAuthenticationBloc].
  /// A function callback for the actual [onPressed] method.
  const UserProfileAuthenticationButton({
    Key? key,
    required this.buttonText,
    required this.event,
    required this.state,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => UserProfileAuthenticationButtonState();
}

class UserProfileAuthenticationButtonState extends State<UserProfileAuthenticationButton> {
  bool _showInProgressIndicator = false;
  bool _isAuthenticated = false;
  bool _isNotAuthenticated = true;
  bool _registrationInProgress = false;

  @override
  Widget build(BuildContext context) {
    _isAuthenticated = widget.state is UserProfileAuthenticatedState;
    _isNotAuthenticated = widget.state is UserProfileNotAuthenticatedState;
    _registrationInProgress = widget.state is UserProfileRegistrationInProgressState;

    _showInProgressIndicator = evaluateProgressIndicatorState(widget.event, widget.state);

    return ElevatedButton(
      style: Theme.of(context).elevatedButtonTheme.style,
      onPressed: _showInProgressIndicator ? null : widget.onPressed,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Opacity(
            opacity: _showInProgressIndicator ? 0 : 1,
            child: Text(
              widget.buttonText,
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
          Opacity(
            opacity: _showInProgressIndicator ? 1 : 0,
            child: Transform.scale(
              scale: 0.5,
              child: CircularProgressIndicator(
                strokeWidth: ui_properties.dividerThicknessLarge,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Determines whether the progress indicator is shown or not based on its purpose indicated by the event.
  bool evaluateProgressIndicatorState(Type event, UserProfileAuthenticationState state) {
    bool loginInProgress = state is UserProfileLoginInProgressState;
    bool loginVerification = state is UserProfileLoginVerificationInProgressState;
    bool registrationVerification = state is UserProfileRegistrationVerificationInProgressState;
    bool signInInProgress = state is UserProfileSignInInProgressState;
    bool logoutInProgress = state is UserProfileLogoutInProgressState;
    bool returnValue = false;

    if (event == UserProfileLoginEvent) {
      returnValue = loginInProgress || loginVerification || _isAuthenticated;
    } else if (event == UserProfileRegistrationEvent) {
      returnValue = registrationVerification || _registrationInProgress;
    } else if (event == UserProfileSignInEvent) {
      returnValue = signInInProgress || _isAuthenticated;
    } else if (event == UserProfileLogoutEvent) {
      returnValue = logoutInProgress || _isNotAuthenticated;
    }
    return returnValue;
  }
}
