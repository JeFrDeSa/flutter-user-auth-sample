import 'package:u_auth/core/utilities/user_notification/bloc_user_notification/user_notification_dialog_bloc.dart';
import 'package:u_auth/core/utilities/user_notification/user_notification_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../test_utilities/fixtures/widget_test_container_fixtures.dart' as test_container_fixtures;

/// Dart test cases for [UserNotificationDialog] widget.
void main() {
  final UserNotificationDialogBloc userNotificationDialogBloc = UserNotificationDialogBloc();

  Widget widgetTestContainer(UserNotificationDialogBloc userNotificationDialogBloc) {
    return test_container_fixtures.getWidgetTestContainerWithNotificationDialogBloc(
      Stack(children: const <Widget>[UserNotificationDialog(key: ValueKey("dialogKey"))]),
      userNotificationDialogBloc,
    );
  }

  void setShowDialogState(String feedbackMessage) {
    userNotificationDialogBloc.add(ShowUserNotificationDialogEvent(message: feedbackMessage));
  }

  void defaultActAssert(WidgetTester tester, String dialogMessage, int dialogPosition) {
    // (A)ct -> on the object or method under test.
    final notificationPosition = tester.getTopLeft(find.byKey(const ValueKey("dialogKey"))).dx;
    final notificationIcon = find.byType(Icon);
    final notificationMessage = find.text(dialogMessage);

    // (A)ssert -> that the expected results have occurred.
    expect(notificationPosition, dialogPosition);
    expect(notificationIcon, findsOneWidget);
    expect(notificationMessage, findsOneWidget);
  }

  testWidgets('should show the predefined layout of the dialog widget when created.', (WidgetTester tester) async {
    // (A)rrange -> all necessary preconditions and inputs.
    await tester.pumpWidget(widgetTestContainer(userNotificationDialogBloc));
    String initialMessage = "";

    defaultActAssert(tester, initialMessage, -500);
  });

  testWidgets('should show the event message in the dialog widget when created.', (WidgetTester tester) async {
    // (A)rrange -> all necessary preconditions and inputs.
    String feedbackMessage = "Invalid password!";
    setShowDialogState(feedbackMessage);
    await tester.pumpWidget(widgetTestContainer(userNotificationDialogBloc));

    defaultActAssert(tester, feedbackMessage, -15);
  });
}
