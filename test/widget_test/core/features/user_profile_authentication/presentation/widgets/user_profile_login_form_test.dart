import 'package:u_auth/core/features/user_profile_authentication/presentation/bloc_user_profile_authentication/user_profile_authentication_bloc.dart';
import 'package:u_auth/core/features/user_profile_authentication/presentation/widgets/user_profile_login_form.dart';
import 'package:u_auth/core/utilities/constants.dart' as constants;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../test_utilities/fixtures/widget_test_container_fixtures.dart' as test_container_fixtures;
import '../../../../../../test_utilities/mocks/use_cases.dart' as use_case_mocks;

/// Dart test cases for the [UserProfileLoginForm] widget.
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
      const UserProfileLoginForm(),
      userProfileAuthenticationBloc,
    );
  }

  // Test case groups
  group('Layout Components', () {
    // Test cases
    testWidgets('should show the initial user profile login form layout relevant widgets when created.',
        (WidgetTester tester) async {
      // (A)rrange -> all necessary preconditions and inputs.
      await tester.pumpWidget(getWidgetTestContainer());

      // (A)ct -> on the object or method under test.
      Finder loginField = find.byKey(constants.userProfileLoginFieldKey);
      Finder passwordField = find.byKey(constants.userProfilePasswordFieldKey);
      Finder loginButton = find.byKey(constants.userProfileLoginButtonKey);

      // (A)ssert -> that the expected results have occurred.
      expect(loginField, findsOneWidget);
      expect(passwordField, findsOneWidget);
      expect(loginButton, findsOneWidget);
    });
  });
}
