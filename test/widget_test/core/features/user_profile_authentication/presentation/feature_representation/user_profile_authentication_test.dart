import 'package:u_auth/core/features/user_profile_authentication/presentation/bloc_user_profile_authentication/user_profile_authentication_bloc.dart';
import 'package:u_auth/core/features/user_profile_authentication/presentation/feature_representation/user_profile_authentication.dart';
import 'package:u_auth/core/utilities/constants.dart' as constants;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../test_utilities/fixtures/widget_test_container_fixtures.dart' as test_container_fixtures;
import '../../../../../../test_utilities/mocks/use_cases.dart' as use_case_mocks;

/// Dart test cases for the [UserProfileAuthentication] widget.
void main() {
  late UserProfileAuthenticationBloc userProfileAuthenticationBloc;

  setUp(() {
    userProfileAuthenticationBloc = UserProfileAuthenticationBloc(
      useCaseVerifyUserProfile: use_case_mocks.verifyUserProfile,
      useCaseRegisterUserProfile: use_case_mocks.registerUserProfile,
      useCaseLoginUserProfile: use_case_mocks.loginUserProfile,
    );
  });

  Widget getWidgetTestContainer() {
    return test_container_fixtures.getWidgetTestContainerWithAuthenticationBloc(
      const UserProfileAuthentication(),
      userProfileAuthenticationBloc,
    );
  }

  // Test cases
  testWidgets('should show the initial user profile authentication layout relevant widgets when created.',
      (WidgetTester tester) async {
    // (A)rrange -> all necessary preconditions and inputs.
    await tester.pumpWidget(getWidgetTestContainer());

    // (A)ct -> on the object or method under test.
    Finder applicationLogo = find.byKey(constants.applicationLogoKey);
    Finder userProfileAuthenticationLoginField = find.byKey(constants.userProfileLoginFieldKey);
    Finder userProfileAuthenticationPasswordField = find.byKey(constants.userProfilePasswordFieldKey);
    Finder userProfileAuthenticationLoginButton = find.byKey(constants.userProfileLoginButtonKey);
    Finder userProfileAuthenticationRegisterButton = find.byKey(constants.userProfileRegisterButtonKey);

    // (A)ssert -> that the expected results have occurred.
    expect(applicationLogo, findsOneWidget);
    expect(userProfileAuthenticationLoginField, findsOneWidget);
    expect(userProfileAuthenticationPasswordField, findsOneWidget);
    expect(userProfileAuthenticationLoginButton, findsOneWidget);
    expect(userProfileAuthenticationRegisterButton, findsOneWidget);
  });
}
