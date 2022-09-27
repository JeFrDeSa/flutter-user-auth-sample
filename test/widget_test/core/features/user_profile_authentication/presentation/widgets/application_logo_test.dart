import 'package:u_auth/core/features/user_profile_authentication/presentation/widgets/application_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../test_utilities/fixtures/widget_test_container_fixtures.dart' as test_container_fixtures;

/// Dart test cases for the [ApplicationLogo] widget.
void main() {
  // Create test and mock test objects here
  Widget getWidgetTestContainer() {
    return test_container_fixtures.getWidgetTestContainer(const ApplicationLogo());
  }

  // Widget test case
  testWidgets('should show the predefined image when created.', (WidgetTester tester) async {
    // (A)rrange -> create the widget by telling tester to build it.
    await tester.pumpWidget(getWidgetTestContainer());

    // (A)ct -> on the object or method under test.
    final applicationLogo = find.byType(Image);

    // (A)ssert -> that the expected results have occurred.
    expect(applicationLogo, findsOneWidget);
  });
}
