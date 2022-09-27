// coverage:ignore-file

import 'package:flutter/material.dart';

/// The predefined size for a widget with rounded boarders.
const Radius widgetBoarderRadius = Radius.circular(7.0);

/// The predefined size for a small widget elevation.
const double widgetElevationSmall = 2.0;

/// The predefined size for a medium widget elevation.
const double widgetElevationMedium = 6.0;

/// The predefined size for a large widget elevation.
const double widgetElevationLarge = 10.0;

const double _smallThickness = 0.00125;
const double _mediumThickness = _smallThickness * 2;
const double _largeThickness = _smallThickness * 3;

/// The predefined size for a small divider thickness.
final double dividerThicknessSmall = MediaQueryDataOfContext.logicalDevicePixelHeight * _smallThickness;

/// The predefined size for a medium divider thickness.
final double dividerThicknessMedium = MediaQueryDataOfContext.logicalDevicePixelHeight * _mediumThickness;

/// The predefined size for a large divider thickness.
final double dividerThicknessLarge = MediaQueryDataOfContext.logicalDevicePixelHeight * _largeThickness;

const double _smallIconSize = 0.04;
const double _mediumIconSize = _smallIconSize * 1.5;
const double _largeIconSize = _smallIconSize * 2.5;

/// The predefined size for a small icon widget.
final double iconSizeSmall = MediaQueryDataOfContext.logicalDevicePixelWidth * _smallIconSize;

/// The predefined size for a medium icon widget.
final double iconSizeMedium = MediaQueryDataOfContext.logicalDevicePixelWidth * _mediumIconSize;

/// The predefined size for a big icon widget.
final double iconSizeLarge = MediaQueryDataOfContext.logicalDevicePixelWidth * _largeIconSize;

const double _smallPadding = 0.01;
const double _mediumPadding = _smallPadding * 2;
const double _largePadding = _smallPadding * 4;

/// The predefined size for a small horizontal widget padding.
final double paddingHorizontalSmall = MediaQueryDataOfContext.logicalDevicePixelWidth * _smallPadding;

/// The predefined size for a medium horizontal widget padding.
final double paddingHorizontalMedium = MediaQueryDataOfContext.logicalDevicePixelWidth * _mediumPadding;

/// The predefined size for a big horizontal widget padding.
final double paddingHorizontalLarge = MediaQueryDataOfContext.logicalDevicePixelWidth * _largePadding;

/// The predefined size for a small vertical widget padding.
final double paddingVerticalSmall =
    MediaQueryDataOfContext.logicalDevicePixelHeight / MediaQueryDataOfContext.aspectRatio * _smallPadding;

/// The predefined size for a medium vertical widget padding.
final double paddingVerticalMedium =
    MediaQueryDataOfContext.logicalDevicePixelHeight / MediaQueryDataOfContext.aspectRatio * _mediumPadding;

/// The predefined size for a big vertical widget padding.
final double paddingVerticalLarge =
    MediaQueryDataOfContext.logicalDevicePixelHeight / MediaQueryDataOfContext.aspectRatio * _largePadding;

/// The smallest padding for all widget sides.
final EdgeInsets paddingSmall = EdgeInsets.only(
  left: paddingHorizontalSmall,
  right: paddingHorizontalSmall,
  top: paddingVerticalSmall,
  bottom: paddingVerticalSmall,
);

/// The medium padding for all widget sides.
final EdgeInsets paddingMedium = EdgeInsets.only(
  left: paddingHorizontalMedium,
  right: paddingHorizontalMedium,
  top: paddingVerticalMedium,
  bottom: paddingVerticalMedium,
);

/// The biggest padding for all widget sides.
final EdgeInsets paddingLarge = EdgeInsets.only(
  left: paddingHorizontalLarge,
  right: paddingHorizontalLarge,
  top: paddingVerticalLarge,
  bottom: paddingVerticalLarge,
);

/// A specific padding used for [FormField]s.
final EdgeInsets formFieldPadding = EdgeInsets.only(
  left: paddingHorizontalMedium,
  right: paddingHorizontalMedium,
  top: paddingVerticalSmall,
  bottom: paddingVerticalSmall,
);

/// Defines [MediaQueryData] related properties.
/// {@category Utilities}
class MediaQueryDataOfContext {
  static late MediaQueryData _mediaQueryData;

  /// Updates the stored [MediaQueryData] based on the application context.
  static void update(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
  }

  /// The aspect ratio of the media
  static double get aspectRatio => _mediaQueryData.devicePixelRatio;

  /// The width of the media in logical pixels.
  static double get logicalDevicePixelWidth => _mediaQueryData.size.width;

  /// The height of the media in logical pixels.
  static double get logicalDevicePixelHeight => _mediaQueryData.size.height;

  /// The available height for widget of the media in logical pixels.
  static double get availableLogicalDevicePixelHeight => logicalDevicePixelHeight - kToolbarHeight - kBottomNavigationBarHeight;
}
