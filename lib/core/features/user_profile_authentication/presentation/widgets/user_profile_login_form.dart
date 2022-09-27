import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:u_auth/core/features/user_profile_authentication/presentation/bloc_user_profile_authentication/user_profile_authentication_bloc.dart';
import 'package:u_auth/core/features/user_profile_authentication/presentation/widgets/text_divider.dart';
import 'package:u_auth/core/features/user_profile_authentication/presentation/widgets/user_profile_authentication_button.dart';
import 'package:u_auth/core/utilities/constants.dart' as constants;
import 'package:u_auth/core/utilities/ui_properties.dart' as ui_properties;

/// This widget represents the user login by providing a [Form] for login credentials
/// {@Category Widgets}
class UserProfileLoginForm extends StatefulWidget {
  const UserProfileLoginForm({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => UserProfileLoginFormState();
}

class UserProfileLoginFormState extends State<UserProfileLoginForm> {
  /// The identifier of the requested user profile
  String _identifier = "";

  /// The password of the requested user profile
  String _password = "";

  @override
  Widget build(BuildContext context) {
    return Form(
      key: constants.userProfileLoginFormKey,
      child: BlocBuilder<UserProfileAuthenticationBloc, UserProfileAuthenticationState>(
        builder: (context, state) {
          return Column(
            children: <Widget>[
              SizedBox(height: ui_properties.paddingVerticalMedium),
              Text(
                "Already registered?",
                style: Theme.of(context).textTheme.bodyText1,
                textAlign: TextAlign.center,
              ),
              Text(
                "Enter your personal user login and password.",
                style: Theme.of(context).textTheme.bodyText1,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: ui_properties.paddingVerticalMedium),
              Container(
                padding: ui_properties.formFieldPadding,
                child: TextFormField(
                  key: constants.userProfileLoginFieldKey,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecoration(
                    contentPadding: ui_properties.paddingSmall,
                    border: const OutlineInputBorder(),
                    icon: Icon(Icons.person, color: Theme.of(context).iconTheme.color),
                    labelText: 'User Login',
                  ),
                  onSaved: (String? value) {
                    _identifier = value!;
                  },
                  validator: (String? value) {
                    if (value != null) {
                      return _formFieldValidation(value: value, minChar: 4, maxChar: 16);
                    }
                    return null;
                  },
                ),
              ),
              Container(
                padding: ui_properties.formFieldPadding,
                child: TextFormField(
                  key: constants.userProfilePasswordFieldKey,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecoration(
                    contentPadding: ui_properties.paddingSmall,
                    border: const OutlineInputBorder(),
                    icon: Icon(Icons.lock_rounded, color: Theme.of(context).iconTheme.color),
                    labelText: 'Password',
                  ),
                  onSaved: (String? value) {
                    _password = value!;
                  },
                  validator: (String? value) {
                    if (value != null) {
                      return _formFieldValidation(value: value, minChar: 3, maxChar: 16);
                    }
                    return null;
                  },
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: ui_properties.paddingVerticalMedium),
                  child: UserProfileAuthenticationButton(
                    key: constants.userProfileLoginButtonKey,
                    buttonText: "Login",
                    event: UserProfileLoginEvent,
                    state: state,
                    onPressed: () {
                      final GlobalKey<FormState> formKey = constants.userProfileLoginFormKey;
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        BlocProvider.of<UserProfileAuthenticationBloc>(context)
                            .add(UserProfileLoginEvent(identifier: _identifier, password: _password));
                      }
                    },
                  ),
                ),
              ),
              SizedBox(height: ui_properties.paddingVerticalMedium),
              const TextDivider(text: "OR"),
              SizedBox(height: ui_properties.paddingVerticalMedium),
              Text(
                "Enter new credentials to create your personal user profile.",
                style: Theme.of(context).textTheme.bodyText1,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: ui_properties.paddingVerticalMedium),
              Align(
                alignment: Alignment.center,
                child: UserProfileAuthenticationButton(
                  key: constants.userProfileRegisterButtonKey,
                  buttonText: "Create new User Profile",
                  event: UserProfileRegistrationEvent,
                  state: state,
                  onPressed: () {
                    final GlobalKey<FormState> formKey = constants.userProfileLoginFormKey;
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      BlocProvider.of<UserProfileAuthenticationBloc>(context)
                          .add(UserProfileRegistrationEvent(identifier: _identifier, password: _password));
                    }
                  },
                ),
              ),
              SizedBox(height: ui_properties.paddingVerticalMedium),
            ],
          );
        },
      ),
    );
  }

  String? _formFieldValidation({required String value, required int minChar, required int maxChar}) {
    bool validation = (value.length >= minChar && value.length <= maxChar && RegExp(r"^[a-z A-Z 0-9]{3,16}$").hasMatch(value));
    return validation ? null : "$minChar to $maxChar characters of: [a-z] [A-Z] [0-9]";
  }
}
