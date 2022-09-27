import 'package:flutter/material.dart';
import 'package:u_auth/core/utilities/ui_properties.dart' as ui_properties;

/// This widgets represents a [Text] with a leading and ending [Divider]
/// {Category Widgets}
class TextDivider extends StatelessWidget {
  /// The text of the [TextDivider] widget.
  final String text;

  /// Creates a [Text] widget with a leading and ending [Divider].
  const TextDivider({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Divider(
            color: Theme.of(context).iconTheme.color,
            indent: ui_properties.paddingHorizontalSmall,
            endIndent: ui_properties.paddingHorizontalMedium,
            thickness: ui_properties.dividerThicknessSmall,
          ),
        ),
        Text(text, style: Theme.of(context).textTheme.bodyText1),
        Expanded(
          child: Divider(
            color: Theme.of(context).iconTheme.color,
            indent: ui_properties.paddingHorizontalMedium,
            endIndent: ui_properties.paddingHorizontalSmall,
            thickness: ui_properties.dividerThicknessSmall,
          ),
        ),
      ],
    );
  }
}
