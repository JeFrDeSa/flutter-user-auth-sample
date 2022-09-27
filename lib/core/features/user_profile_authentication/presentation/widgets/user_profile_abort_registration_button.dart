import 'package:u_auth/core/features/user_profile_authentication/presentation/bloc_user_profile_authentication/user_profile_authentication_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// This widget represent the abort button of the [UserProfileRegistrationForm] widget.
/// {Category Widgets}
class UserProfileAbortRegistrationButton extends StatelessWidget {
  const UserProfileAbortRegistrationButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: Theme.of(context).textButtonTheme.style,
      onPressed: () {
        BlocProvider.of<UserProfileAuthenticationBloc>(context).add(const UserProfileAbortRegistrationEvent());
      },
      child: Icon(Icons.arrow_back_rounded, color: Theme.of(context).iconTheme.color),
    );
  }
}
