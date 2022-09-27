import 'package:u_auth/core/features/user_profile_authentication/presentation/bloc_user_profile_authentication/user_profile_authentication_bloc.dart';
import 'package:u_auth/core/features/user_profile_authentication/presentation/widgets/user_profile_abort_registration_button.dart';
import 'package:u_auth/core/features/user_profile_authentication/presentation/widgets/user_profile_authentication_button.dart';
import 'package:u_auth/core/features/user_profile_authentication/presentation/widgets/user_profile_login_form.dart';
import 'package:u_auth/core/utilities/constants.dart' as constants;
import 'package:u_auth/core/utilities/ui_properties.dart' as ui_properties;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// This widget represents the user registration by providing a [Form] for user credentials
/// {@Category Widgets}
class UserProfileRegistrationForm extends StatefulWidget {
  const UserProfileRegistrationForm({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => UserProfileRegistrationFormState();
}

class UserProfileRegistrationFormState extends State<UserProfileRegistrationForm> {
  /// The first name of the new user profile.
  String _firstName = "";

  /// The last name of the new user profile.
  String _lastName = "";

  /// The e-mail address of the new user profile.
  String _eMail = "";

  /// The identifier received from the [UserProfileLoginForm].
  String _identifier = "";

  /// The password received from the [UserProfileLoginForm].
  String _password = "";

  @override
  Widget build(BuildContext context) {
    return Form(
      key: constants.userProfileRegistrationFormKey,
      child: BlocBuilder<UserProfileAuthenticationBloc, UserProfileAuthenticationState>(
        builder: (context, state) {
          if (state is UserProfileRegistrationInProgressState) {
            _identifier = state.identifier;
            _password = state.password;
          }
          return Column(
            children: <Widget>[
              SizedBox(height: ui_properties.paddingVerticalMedium),
              Row(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    child: const UserProfileAbortRegistrationButton(key: constants.userProfileAbortRegistrationButtonKey),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(right: ui_properties.paddingHorizontalMedium),
                      child: Text(
                        "Enter the following user credentials\n to create your own user profile!",
                        style: Theme.of(context).textTheme.bodyText1,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: ui_properties.paddingVerticalMedium),
              Container(
                padding: ui_properties.formFieldPadding,
                child: TextFormField(
                  key: constants.userProfileFirstNameFieldKey,
                  enableSuggestions: true,
                  autocorrect: false,
                  decoration: InputDecoration(
                    contentPadding: ui_properties.paddingSmall,
                    border: const OutlineInputBorder(),
                    icon: Icon(Icons.person, color: Theme.of(context).iconTheme.color),
                    labelText: 'First Name',
                  ),
                  onSaved: (String? value) {
                    _firstName = value!;
                  },
                  validator: (String? value) {
                    if (value != null) {
                      return _formFieldValidation(value: value, maxChar: 16);
                    }
                    return null;
                  },
                ),
              ),
              Container(
                padding: ui_properties.formFieldPadding,
                child: TextFormField(
                  key: constants.userProfileLastNameFieldKey,
                  enableSuggestions: true,
                  autocorrect: false,
                  decoration: InputDecoration(
                    contentPadding: ui_properties.paddingSmall,
                    border: const OutlineInputBorder(),
                    icon: const Icon(Icons.mail_rounded, color: Colors.transparent),
                    labelText: 'Last Name',
                  ),
                  onSaved: (String? value) {
                    _lastName = value!;
                  },
                  validator: (String? value) {
                    if (value != null) {
                      return _formFieldValidation(value: value, maxChar: 16);
                    }
                    return null;
                  },
                ),
              ),
              Container(
                padding: ui_properties.formFieldPadding,
                child: TextFormField(
                  key: constants.userProfileEMailFieldKey,
                  enableSuggestions: true,
                  autocorrect: false,
                  decoration: InputDecoration(
                    contentPadding: ui_properties.paddingSmall,
                    border: const OutlineInputBorder(),
                    icon: Icon(Icons.mail_rounded, color: Theme.of(context).iconTheme.color),
                    labelText: 'E-Mail',
                  ),
                  onSaved: (String? value) {
                    _eMail = value!;
                  },
                  validator: (String? value) {
                    if (value != null) {
                      return _eMailFormFieldValidation(value: value);
                    }
                    return null;
                  },
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: ui_properties.paddingHorizontalMedium),
                  child: UserProfileAuthenticationButton(
                    key: constants.userProfileSignInButtonKey,
                    buttonText: "Create new User Profile",
                    event: UserProfileSignInEvent,
                    state: state,
                    onPressed: () {
                      final GlobalKey<FormState> formKey = constants.userProfileRegistrationFormKey;
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        BlocProvider.of<UserProfileAuthenticationBloc>(context).add(UserProfileSignInEvent(
                          identifier: _identifier,
                          password: _password,
                          firstName: _firstName,
                          lastName: _lastName,
                          eMail: _eMail,
                        ));
                      }
                    },
                  ),
                ),
              ),
              SizedBox(height: ui_properties.paddingVerticalMedium),
            ],
          );
        },
      ),
    );
  }

  String? _formFieldValidation({required String value, required int maxChar}) {
    bool regExpResult = RegExp(r"^[a-z A-Z 0-9]{1,16}$").hasMatch(value);
    bool validation = (value.isNotEmpty && value.length <= maxChar && regExpResult);
    return validation ? null : "Max. $maxChar characters of: [a-z] [A-Z]";
  }

  String? _eMailFormFieldValidation({required String value}) {
    bool regExpResult = RegExp(r"^[a-z A-Z 0-9 !#$%&'*+-/=?^_`{|}~]{1,32}@[a-z 0-9 -]{1,32}.[a-z]{1,4}$").hasMatch(value);
    bool validation = (value.length >= 6 && value.length < 69 && regExpResult);
    return validation ? null : "Invalid e-mail address";
  }
}
