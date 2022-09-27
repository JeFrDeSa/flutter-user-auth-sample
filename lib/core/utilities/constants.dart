// coverage:ignore-file

import 'package:u_auth/core/errors/exceptions/exceptions.dart';
import 'package:u_auth/core/errors/failures/failures.dart';
import 'package:u_auth/core/features/user_profile_authentication/presentation/feature_representation/user_profile_authentication.dart';
import 'package:u_auth/core/features/user_profile_authentication/presentation/widgets/application_logo.dart';
import 'package:u_auth/core/features/user_profile_authentication/presentation/widgets/user_profile_login_form.dart';
import 'package:u_auth/core/features/user_profile_authentication/presentation/widgets/user_profile_registration_form.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

const String userProfileVerificationFailureCode = "0x01";
const String userProfileAccessFailureCode = "0x02";

/// The duration the dialog is displayed.
const Duration userNotificationDialogDisplayDuration = Duration(seconds: 4);

/// The shortest animation duration of all animations.
const Duration getAnimationDurationS = Duration(milliseconds: 250);

/// The medium animation duration of all animations.
const Duration getAnimationDurationM = Duration(milliseconds: 350);

/// The longest animation duration of all animations.
const Duration getAnimationDurationL = Duration(milliseconds: 450);

/// The availability states of [UserProfile] related data.
enum UserProfileDataState {isAvailable, isNotAvailable}

/// Defines a standard type to return instead of [MyFailures] or [MyExceptions].
/// {@category Utilities}
class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}

/// The dark theme application logo asset
final Image darkThemeLogo = Image.asset("assets/images/dark_theme_logo.png");

/// The light theme application logo asset
final Image lightThemeLogo = Image.asset("assets/images/light_theme_logo.png");

/// The key for the title [Text] widget.
const ValueKey pageTitleKey = ValueKey("pageTitleKey");

/// The key for the [ApplicationLogo] widget.
const ValueKey applicationLogoKey = ValueKey("applicationLogoKey");

/// The key for the [UserNotificationDialog] widget.
const ValueKey userNotificationDialogKey = ValueKey("userNotificationDialogKey");

/// The key for the [UserProfileAuthentication] widget.
const ValueKey userProfileAuthenticationKey = ValueKey("userProfileAuthenticationKey");

/// The key for the [UserProfileLoginForm] widget.
const ValueKey userProfileLoginKey = ValueKey("userProfileLoginKey");

/// The GlobalKey for the [Form] of the [UserProfileLoginForm] widget.
final GlobalKey<FormState> userProfileLoginFormKey = GlobalKey();

/// The key for the login field of the [UserProfileLoginForm] widget.
const ValueKey userProfileLoginFieldKey = ValueKey("userProfileLoginFieldKey");

/// The key for the password field of the [UserProfileLoginForm] widget.
const ValueKey userProfilePasswordFieldKey = ValueKey("userProfilePasswordFieldKey");

/// The key for the login button of the [UserProfileLoginForm] widget.
const ValueKey userProfileLoginButtonKey = ValueKey("userProfileLoginButtonKey");

/// The key for the registration button of the [UserProfileLoginForm] widget.
const ValueKey userProfileRegisterButtonKey = ValueKey("userProfileRegisterButtonKey");

/// The key for the [UserProfileRegistrationForm] widget.
const ValueKey userProfileRegistrationKey = ValueKey("userProfileRegistrationKey");

/// The GlobalKey for the [Form] of the [UserProfileRegistrationForm] widget.
GlobalKey<FormState> userProfileRegistrationFormKey = GlobalKey();

/// The key for the first name field of the [UserProfileRegistrationForm] widget.
const ValueKey userProfileFirstNameFieldKey = ValueKey("userProfileFirstNameFieldKey");

/// The key for the last name field of the [UserProfileRegistrationForm] widget.
const ValueKey userProfileLastNameFieldKey = ValueKey("userProfileLastNameFieldKey");

/// The key for the e-mail button of the [UserProfileRegistrationForm] widget.
const ValueKey userProfileEMailFieldKey = ValueKey("userProfileEMailFieldKey");

/// The key for the sign in button of the [UserProfileRegistrationForm] widget.
const ValueKey userProfileSignInButtonKey = ValueKey("userProfileSignInButtonKey");

/// The key for the abort button of the [UserProfileRegistrationForm] widget.
const ValueKey userProfileAbortRegistrationButtonKey = ValueKey("userProfileAbortRegistrationButtonKey");
