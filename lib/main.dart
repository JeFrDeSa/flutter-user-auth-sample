import 'package:u_auth/core/features/user_profile_authentication/presentation/bloc_user_profile_authentication/user_profile_authentication_bloc.dart';
import 'package:u_auth/core/utilities/constants.dart' as constants;
import 'package:u_auth/core/utilities/theme_data.dart' as theme_data;
import 'package:u_auth/core/utilities/ui_properties.dart' as ui_properties;
import 'package:u_auth/core/utilities/user_notification/bloc_user_notification/user_notification_dialog_bloc.dart';
import 'package:u_auth/core/utilities/user_notification/user_notification_dialog.dart';
import 'package:u_auth/features/temp_feature_blue/presentation/feature_representation/blue_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'injection_container.dart' as dependency_injection;

void main() async {
  // Ensures an instance of the WidgetsBinding is available.
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize the by the Application Service Locator registered services.
  await dependency_injection.init();
  // Specifies the valid application orientation to: only portrait.
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  // Inflate the given widget and attach it to the screen.
  runApp(const AppInstance());
}

/// Defines the application instance.
///
/// Returns a [MaterialApp] widget as root.
/// {@category Widgets}
class AppInstance extends StatefulWidget {
  /// Creates a stateful widget of the [AppInstance].
  const AppInstance({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => AppInstanceStace();
}

class AppInstanceStace extends State<AppInstance> {
  // Application light theme as defined in the core/test_utilities.
  final lightTheme = theme_data.lightTheme;

  // Application dark theme as defined in the core/test_utilities.
  final darkTheme = theme_data.darkTheme;

  // The used [UserAuthenticationBloc] for the [UserAuthentication].
  late UserProfileAuthenticationBloc _userProfileAuthenticationBloc;

  // The used [UserNotificationDialogBloc] for the [UserNotification].
  late UserNotificationDialogBloc _userNotificationDialogBloc;

  @override
  void initState() {
    super.initState();
    _userProfileAuthenticationBloc = dependency_injection.serviceLocator<UserProfileAuthenticationBloc>();
    _userNotificationDialogBloc = dependency_injection.serviceLocator<UserNotificationDialogBloc>();
  }

  @override
  void dispose() {
    _userProfileAuthenticationBloc.close();
    _userNotificationDialogBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Widget title for Android
      title: 'User Authentication Demo',
      // Disable debug banner
      debugShowCheckedModeBanner: false,
      // Set theme for Light Mode
      theme: lightTheme,
      // Set theme for Dark Mode
      darkTheme: darkTheme,
      // Definition of the application initial entry point
      initialRoute: const ValueKey("bluePage").value,
      // Definition of the application routes
      routes: {
        const ValueKey("bluePage").value: (context) {
          return preparePage(pageRepresentation: const BluePage(key: ValueKey("bluePage")), currentContext: context);
        },
      },
    );
  }

  Widget preparePage({required Widget pageRepresentation, required BuildContext currentContext}) {
    ui_properties.MediaQueryDataOfContext.update(currentContext);
    return BlocBuilder<UserProfileAuthenticationBloc, UserProfileAuthenticationState>(
      bloc: _userProfileAuthenticationBloc,
      builder: (context, state) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: _userNotificationDialogBloc),
            BlocProvider.value(value: _userProfileAuthenticationBloc),
          ],
          child: Stack(
            children: <Widget>[
              pageRepresentation,
              const UserNotificationDialog(key: constants.userNotificationDialogKey),
            ],
          ),
        );
      },
    );
  }
}
