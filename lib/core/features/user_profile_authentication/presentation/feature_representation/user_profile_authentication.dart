import 'package:u_auth/core/features/user_profile_authentication/presentation/bloc_user_profile_authentication/user_profile_authentication_bloc.dart';
import 'package:u_auth/core/features/user_profile_authentication/presentation/widgets/application_logo.dart';
import 'package:u_auth/core/features/user_profile_authentication/presentation/widgets/user_profile_login_form.dart';
import 'package:u_auth/core/features/user_profile_authentication/presentation/widgets/user_profile_registration_form.dart';
import 'package:u_auth/core/utilities/constants.dart' as constants;
import 'package:u_auth/core/utilities/ui_properties.dart' as ui_properties;
import 'package:u_auth/core/utilities/ui_properties.dart';
import 'package:u_auth/core/utilities/user_notification/bloc_user_notification/user_notification_dialog_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// This widget represents the user profile authentication by the [UserProfileLoginForm] and [UserProfileRegistrationForm] widgets.
/// {@category Widget}
class UserProfileAuthentication extends StatefulWidget {
  const UserProfileAuthentication({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _UserProfileAuthenticationState();
}

class _UserProfileAuthenticationState extends State<UserProfileAuthentication> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      padding: ui_properties.paddingSmall,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              width: MediaQueryDataOfContext.logicalDevicePixelWidth * 0.5,
              child: const ApplicationLogo(key: constants.applicationLogoKey),
            ),
            BlocBuilder<UserProfileAuthenticationBloc, UserProfileAuthenticationState>(
              builder: (context, state) {
                if (state is UserProfileAuthenticationFailureState) {
                  BlocProvider.of<UserNotificationDialogBloc>(context).add(
                    ShowUserNotificationDialogEvent(message: state.failureMessage),
                  );
                }
                bool regForm = state is UserProfileRegistrationInProgressState || state is UserProfileSignInInProgressState;
                return BlocProvider.value(
                  value: BlocProvider.of<UserProfileAuthenticationBloc>(context),
                  child: Card(
                    elevation: Theme.of(context).cardTheme.elevation,
                    shape: Theme.of(context).cardTheme.shape,
                    color: Theme.of(context).cardTheme.color,
                    child: Container(
                      padding: ui_properties.paddingSmall,
                      child: AnimatedCrossFade(
                        crossFadeState: regForm ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                        duration: constants.getAnimationDurationM,
                        firstCurve: Curves.easeOutExpo,
                        secondCurve: Curves.easeInCirc,
                        firstChild: const UserProfileRegistrationForm(key: constants.userProfileRegistrationKey),
                        secondChild: const UserProfileLoginForm(key: constants.userProfileLoginKey),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
