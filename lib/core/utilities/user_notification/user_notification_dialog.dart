import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:u_auth/core/utilities/constants.dart' as constants;
import 'package:u_auth/core/utilities/ui_properties.dart' as ui_properties;
import 'package:u_auth/core/utilities/ui_properties.dart';
import 'package:u_auth/core/utilities/user_notification/bloc_user_notification/user_notification_dialog_bloc.dart';

/// This widget represents the user notification pop up dialog.
/// {@category Utilities}
class UserNotificationDialog extends StatefulWidget {
  /// Creates a stateful widget of the [UserNotificationDialog].
  const UserNotificationDialog({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _UserNotificationDialogState();
}

class _UserNotificationDialogState extends State<UserNotificationDialog> {

  /// The top position of the widget.
  final double topPosition = MediaQueryDataOfContext.availableLogicalDevicePixelHeight;

  /// The left position while hiding the notifier
  final double hidePosition = -500;

  /// The left position while displaying the notifier
  final double showPosition = -15;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserNotificationDialogBloc, UserNotificationDialogState>(builder: (context, state) {
      return AnimatedPositioned(
        duration: constants.getAnimationDurationM,
        left: state is ShowUserNotificationDialogState ? showPosition : hidePosition,
        top: topPosition,
        child: Card(
          shape: Theme.of(context).cardTheme.shape,
          color: Theme.of(context).cardTheme.color,
          child: Container(
            padding: ui_properties.paddingMedium,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(width: ui_properties.paddingHorizontalMedium),
                Icon(Icons.warning_amber_outlined,
                      color: Colors.amberAccent, size: ui_properties.iconSizeSmall),
                SizedBox(width: ui_properties.paddingHorizontalSmall),
                Text(state.message, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodyText1),
              ],
            ),
          ),
        ),
      );
    });
  }
}
