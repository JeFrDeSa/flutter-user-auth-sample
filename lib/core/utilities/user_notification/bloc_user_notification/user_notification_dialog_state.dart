part of 'user_notification_dialog_bloc.dart';

/// Abstract class of [UserNotificationDialogBloc] states.
abstract class UserNotificationDialogState extends Equatable {
  /// User feedback message
  final String message;

  const UserNotificationDialogState({required this.message});

  @override
  List<Object> get props => [message];
}

/// The [UserNotificationDialog] is shown during this state.
class ShowUserNotificationDialogState extends UserNotificationDialogState {
  /// Creates a state during the [UserNotificationDialog] displays a user feedback [message].
  const ShowUserNotificationDialogState({required String message}) : super(message: message);

  @override
  List<Object> get props => [message];
}

/// The [UserNotificationDialog] is not shown during this state.
class HideUserNotificationDialogState extends UserNotificationDialogState {
  /// Creates a state during the [UserNotificationDialog] is hidden.
  const HideUserNotificationDialogState() : super(message: "");

  @override
  List<Object> get props => [message];
}
