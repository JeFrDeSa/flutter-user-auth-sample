import 'package:flutter_test/flutter_test.dart';
import 'package:u_auth/core/utilities/user_notification/bloc_user_notification/user_notification_dialog_bloc.dart';

/// Dart test cases for the [UserNotificationDialogBloc].
void main() {
  late UserNotificationDialogBloc userNotificationBloc;

  setUp(() {
    userNotificationBloc = UserNotificationDialogBloc();
  });

  test('should have the initial state show user notification dialog when called.', () async {
    // (A)ssert -> that the expected results have occurred.
    expect(userNotificationBloc.state, const HideUserNotificationDialogState());
  });

  test('should emit the hide dialog state automatically after the show dialog state occurs.', () async {
    // (A)ssert Later -> that the predefined state order has occurred.
    final expectedStates = [
      const ShowUserNotificationDialogState(message: "Error!"),
      const HideUserNotificationDialogState(),
    ];
    expectLater(userNotificationBloc.stream, emitsInOrder(expectedStates));

    // (A)ct -> on the object or method under test.
    userNotificationBloc.add(const ShowUserNotificationDialogEvent(message: "Error!"));
  });
}
