import 'package:u_auth/core/features/user_profile_authentication/presentation/widgets/text_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../test_utilities/fixtures/widget_test_container_fixtures.dart' as test_container_fixtures;

/// Dart test cases for the [TextDivider] widget.
void main() {
  // Create test and mock test objects here
  Widget getWidgetTestContainer() {
    return test_container_fixtures.getWidgetTestContainer(const TextDivider(text: "Sample Text"));
  }

  // Test cases
  testWidgets('should show two dividers with a text in between when created.', (WidgetTester tester) async {
    // (A)rrange -> all necessary preconditions and inputs.
    await tester.pumpWidget(getWidgetTestContainer());

    // (A)ct -> on the object or method under test.
    Finder dividers = find.byType(Divider);
    Finder text = find.text("Sample Text");

    // (A)ssert -> that the expected results have occurred.
    expect(dividers, findsWidgets);
    expect(text, findsOneWidget);
  });
}
