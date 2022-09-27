import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:u_auth/core/features/user_profile_authentication/presentation/bloc_user_profile_authentication/user_profile_authentication_bloc.dart';
import 'package:u_auth/core/features/user_profile_authentication/presentation/widgets/user_profile_registration_form.dart';
import 'package:u_auth/core/utilities/constants.dart' as constants;

import '../../../../../../test_utilities/fixtures/widget_test_container_fixtures.dart' as test_container_fixtures;
import '../../../../../../test_utilities/mocks/use_cases.dart' as use_case_mocks;

/// Dart test cases for the [UserProfileRegistrationForm] widget.
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
      const UserProfileRegistrationForm(),
      userProfileAuthenticationBloc,
    );
  }

  // Test cases
  testWidgets('should show the initial [user profile registration form] layout when created.', (WidgetTester tester) async {
    // (A)rrange -> all necessary preconditions and inputs.
    await tester.pumpWidget(getWidgetTestContainer());

    // (A)ct -> on the object or method under test.
    Finder abortRegistrationButton = find.byKey(constants.userProfileAbortRegistrationButtonKey);
    Finder firstNameField = find.byKey(constants.userProfileFirstNameFieldKey);
    Finder lastNameField = find.byKey(constants.userProfileLastNameFieldKey);
    Finder eMailField = find.byKey(constants.userProfileEMailFieldKey);
    Finder signInButton = find.byKey(constants.userProfileSignInButtonKey);

    // (A)ssert -> that the expected results have occurred.
    expect(abortRegistrationButton, findsOneWidget);
    expect(firstNameField, findsOneWidget);
    expect(lastNameField, findsOneWidget);
    expect(eMailField, findsOneWidget);
    expect(signInButton, findsOneWidget);
  });
}
