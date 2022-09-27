import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:u_auth/core/utilities/constants.dart' as constants;

part 'user_notification_dialog_event.dart';
part 'user_notification_dialog_state.dart';

/// Handles events and states based on the [Bloc] pattern for displaying the [UserNotificationDialog].
class UserNotificationDialogBloc extends Bloc<UserNotificationDialogEvent, UserNotificationDialogState> {
  /// Whether the dialog is currently displayed to the user.
  bool _dialogIsShown = false;

  UserNotificationDialogBloc() : super(const HideUserNotificationDialogState()) {
    on<UserNotificationDialogEvent>((event, emit) async {
      if (event is ShowUserNotificationDialogEvent) {
        if (_dialogIsShown == false) {
          emit(showDialog(event.message));
          emit(await hideDialog());
        }
      }
    });
  }

  UserNotificationDialogState showDialog(String message) {
    _dialogIsShown = true;
    return ShowUserNotificationDialogState(message: message);
  }

  Future<UserNotificationDialogState> hideDialog() async {
    return await Future.delayed(constants.userNotificationDialogDisplayDuration, () {
      _dialogIsShown = false;
      return const HideUserNotificationDialogState();
    });
  }
}
