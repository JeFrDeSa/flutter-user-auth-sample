import 'package:u_auth/core/features/user_profile_authentication/presentation/bloc_user_profile_authentication/user_profile_authentication_bloc.dart';
import 'package:u_auth/core/features/user_profile_authentication/presentation/widgets/user_profile_abort_registration_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../test_utilities/fixtures/widget_test_container_fixtures.dart' as test_container_fixtures;
import '../../../../../../test_utilities/mocks/use_cases.dart' as use_case_mocks;

/// Dart test cases for the [UserProfileAbortRegistrationButton] widget.
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
      const UserProfileAbortRegistrationButton(),
      userProfileAuthenticationBloc,
    );
  }

  // Test cases
  testWidgets('should show the initial user profile abort registration button layout when created.',
      (WidgetTester tester) async {
    // (A)rrange -> all necessary preconditions and inputs.
    await tester.pumpWidget(getWidgetTestContainer());

    // (A)ct -> on the object or method under test.
    Finder abortButton = find.byIcon(Icons.arrow_back_rounded);

    // (A)ssert -> that the expected results have occurred.
    expect(abortButton, findsOneWidget);
  });
}
