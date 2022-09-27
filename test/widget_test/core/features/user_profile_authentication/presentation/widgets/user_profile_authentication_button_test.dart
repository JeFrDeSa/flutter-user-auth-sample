import 'package:u_auth/core/features/user_profile_authentication/presentation/bloc_user_profile_authentication/user_profile_authentication_bloc.dart';
import 'package:u_auth/core/features/user_profile_authentication/presentation/widgets/user_profile_authentication_button.dart';
import 'package:u_auth/core/utilities/constants.dart' as constants;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../test_utilities/fixtures/widget_test_container_fixtures.dart' as test_container_fixtures;
import '../../../../../../test_utilities/mocks/use_cases.dart' as use_case_mocks;

/// Dart test cases for the [UserProfileRegistrationButton] widget.
void main() {
  late UserProfileAuthenticationBloc userProfileAuthenticationBloc;

  setUp(() {
    userProfileAuthenticationBloc = UserProfileAuthenticationBloc(
      useCaseVerifyUserProfile: use_case_mocks.verifyUserProfile,
      useCaseRegisterUserProfile: use_case_mocks.registerUserProfile,
      useCaseLoginUserProfile: use_case_mocks.loginUserProfile,
    );
  });

  Widget getWidgetTestContainer(UserProfileAuthenticationState state) {
    return test_container_fixtures.getWidgetTestContainerWithAuthenticationBloc(
      UserProfileAuthenticationButton(
        key: constants.userProfileLoginButtonKey,
        buttonText: "Login",
        event: UserProfileLoginEvent,
        state: state,
        onPressed: () {},
      ),
      userProfileAuthenticationBloc,
    );
  }

  Future<void> actAssertButtonTap(WidgetTester tester,
      {required double expectedButtonTextOpacity, required double expectedProgressIndicatorOpacity}) async {
    Finder registrationButton = find.byType(ElevatedButton);
    await tester.tap(registrationButton);
    await tester.pump(const Duration(milliseconds: 250));
    Finder buttonText = find.ancestor(of: find.byType(Text), matching: find.byType(Opacity));
    Finder progressIndicator = find.ancestor(of: find.byType(CircularProgressIndicator), matching: find.byType(Opacity));
    Opacity textOpacity = tester.widget(buttonText);
    Opacity progressIndicatorOpacity = tester.widget(progressIndicator);

    // (A)ssert -> that the expected results have occurred.
    expect(registrationButton, findsOneWidget);
    assert(textOpacity.opacity == expectedButtonTextOpacity);
    assert(progressIndicatorOpacity.opacity == expectedProgressIndicatorOpacity);
  }

  testWidgets('should show the initial user profile login button layout when created.', (WidgetTester tester) async {
    // (A)rrange -> all necessary preconditions and inputs.
    await tester.pumpWidget(getWidgetTestContainer(const UserProfileNotAuthenticatedState()));

    // (A)ct and (A)ssert
    await actAssertButtonTap(tester, expectedButtonTextOpacity: 1, expectedProgressIndicatorOpacity: 0);
  });

  testWidgets('should show the progress indicator when the associated in progress state occur.', (WidgetTester tester) async {
    // (A)rrange -> all necessary preconditions and inputs.
    await tester.pumpWidget(getWidgetTestContainer(const UserProfileLoginInProgressState()));

    // (A)ct and (A)ssert
    await actAssertButtonTap(tester, expectedButtonTextOpacity: 0, expectedProgressIndicatorOpacity: 1);
  });
}
