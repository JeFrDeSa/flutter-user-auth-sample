import 'package:u_auth/core/features/user_profile_authentication/presentation/bloc_user_profile_authentication/user_profile_authentication_bloc.dart';
import 'package:u_auth/core/utilities/theme_data.dart' as theme_data;
import 'package:u_auth/core/utilities/ui_properties.dart';
import 'package:u_auth/core/utilities/user_notification/bloc_user_notification/user_notification_dialog_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The default test container for widget tests.
Widget getWidgetTestContainer(Widget testWidget) {
  return MaterialApp(
    theme: theme_data.lightTheme,
    darkTheme: theme_data.darkTheme,
    home: Builder(builder: (context) {
      MediaQueryDataOfContext.update(context);
      return Container(
        child: testWidget,
      );
    }),
  );
}

/// The test container for widget tests with an [UserNotificationDialogBloc].
Widget getWidgetTestContainerWithNotificationDialogBloc(Widget testWidget, UserNotificationDialogBloc usedBloc) {
  return MaterialApp(
    theme: theme_data.lightTheme,
    darkTheme: theme_data.darkTheme,
    home: Builder(builder: (context) {
      MediaQueryDataOfContext.update(context);
      return BlocProvider.value(
        value: usedBloc,
        child: Scaffold(
          body: testWidget,
        ),
      );
    }),
  );
}

/// The test container for widget tests with an [UserProfileAuthenticationBloc].
Widget getWidgetTestContainerWithAuthenticationBloc(Widget testWidget, UserProfileAuthenticationBloc usedBloc) {
  return MaterialApp(
    theme: theme_data.lightTheme,
    darkTheme: theme_data.darkTheme,
    home: Builder(builder: (context) {
      MediaQueryDataOfContext.update(context);
      return BlocProvider.value(
        value: usedBloc,
        child: Scaffold(
          body: testWidget,
        ),
      );
    }),
  );
}
