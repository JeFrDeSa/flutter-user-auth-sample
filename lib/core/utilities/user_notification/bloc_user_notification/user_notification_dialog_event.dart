part of 'user_notification_dialog_bloc.dart';

/// Abstract class of [UserNotificationDialogBloc] relevant events.
abstract class UserNotificationDialogEvent extends Equatable {
  /// User feedback message
  final String message;

  const UserNotificationDialogEvent({required this.message});

  @override
  List<Object> get props => [message];
}

/// Event to request displaying the [UserNotificationDialog].
class ShowUserNotificationDialogEvent extends UserNotificationDialogEvent {
  /// Creates an event to request displaying the given user feedback [message] in a dialog.
  const ShowUserNotificationDialogEvent({required String message}) : super(message: message);

  @override
  List<Object> get props => [message];
}
