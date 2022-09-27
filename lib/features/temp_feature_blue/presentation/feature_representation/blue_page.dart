import 'package:u_auth/core/features/user_profile_authentication/presentation/bloc_user_profile_authentication/user_profile_authentication_bloc.dart';
import 'package:u_auth/core/features/user_profile_authentication/presentation/feature_representation/user_profile_authentication.dart';
import 'package:u_auth/core/features/user_profile_authentication/presentation/widgets/user_profile_authentication_button.dart';
import 'package:u_auth/core/utilities/constants.dart' as constants;
import 'package:u_auth/core/utilities/ui_properties.dart';
import 'package:u_auth/core/utilities/ui_properties.dart' as ui_properties;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// This widget represents the blue data and serves as entry point after the login/registration.
/// {@category Pages}
class BluePage extends StatefulWidget {
  /// Creates a stateful widget of the [BluePage].
  const BluePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BluePageState();
}

class _BluePageState extends State<BluePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // This ensures the hiding of the soft keyboard by tapping the background
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: BlocBuilder<UserProfileAuthenticationBloc, UserProfileAuthenticationState>(
        bloc: BlocProvider.of<UserProfileAuthenticationBloc>(context),
        builder: (context, state) {
          bool userProfileAuthenticated = state is UserProfileAuthenticatedState || state is UserProfileLogoutInProgressState;
          return Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            appBar: AppBar(
              backgroundColor: Theme.of(context).primaryColor,
              title: AnimatedCrossFade(
                crossFadeState: userProfileAuthenticated ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                duration: constants.getAnimationDurationM,
                firstCurve: Curves.easeOutExpo,
                secondCurve: Curves.easeInCirc,
                firstChild: SizedBox(
                  width: MediaQueryDataOfContext.logicalDevicePixelWidth * 0.5,
                  child: Text(
                    "Blue Page",
                    key: constants.pageTitleKey,
                    style: Theme.of(context).textTheme.headline1,
                    textAlign: TextAlign.center,
                  ),
                ),
                secondChild: SizedBox(
                  width: MediaQueryDataOfContext.logicalDevicePixelWidth * 0.5,
                  child: Text(
                    "User Login",
                    style: Theme.of(context).textTheme.headline1,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              centerTitle: true,
            ),
            body: AnimatedCrossFade(
              crossFadeState: userProfileAuthenticated ? CrossFadeState.showFirst : CrossFadeState.showSecond,
              duration: constants.getAnimationDurationM,
              firstCurve: Curves.easeOutExpo,
              secondCurve: Curves.easeInCirc,
              firstChild: Container(
                height: MediaQueryDataOfContext.availableLogicalDevicePixelHeight,
                alignment: Alignment.center,
                padding: ui_properties.paddingLarge,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: ui_properties.paddingHorizontalMedium),
                      Text(
                        "Press to logout the current user profile!",
                        style: Theme.of(context).textTheme.bodyText1,
                        textAlign: TextAlign.center,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: UserProfileAuthenticationButton(
                          buttonText: "Logout",
                          event: UserProfileLogoutEvent,
                          state: state,
                          onPressed: () {
                            constants.userProfileRegistrationFormKey.currentState!.reset();
                            constants.userProfileLoginFormKey.currentState!.reset();
                            BlocProvider.of<UserProfileAuthenticationBloc>(context).add(const UserProfileLogoutEvent());
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              secondChild: const UserProfileAuthentication(key: constants.userProfileAuthenticationKey),
            ),
          );
        },
      ),
    );
  }

  /// Navigates to the desired page of the [pageKey] via the [BluePage].
  void goToPage(ValueKey pageKey) {
    Navigator.popAndPushNamed(context, pageKey.value);
  }
}
