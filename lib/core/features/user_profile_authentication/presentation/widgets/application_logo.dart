import 'package:u_auth/core/utilities/constants.dart' as constants;
import 'package:u_auth/core/utilities/ui_properties.dart' as ui_properties;
import 'package:flutter/material.dart';

/// This widget represents the application logo, visible during the user profile authentication.
/// {@category Widget}
class ApplicationLogo extends StatelessWidget {
  const ApplicationLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Brightness currentBrightness = MediaQuery.of(context).platformBrightness;
    return Align(
      alignment: Alignment.center,
      child: Container(
        padding: ui_properties.paddingSmall,
        child: currentBrightness == Brightness.dark ? constants.darkThemeLogo : constants.lightThemeLogo,
      ),
    );
  }
}
