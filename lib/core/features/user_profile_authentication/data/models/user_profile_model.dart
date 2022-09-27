// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:u_auth/core/features/user_profile_authentication/domain/entities/user_profile.dart';

/// Defines the user profile authentication related model.
/// {@category Models}
class UserProfileModel extends UserProfile {
  /// Creates a model for stored user profile authentication related information.
  UserProfileModel({required super.identifier, required super.passwordHash});

  /// Returns a model based on a Json string.
  factory UserProfileModel.fromJson(String jsonStr) {
    Map<String, dynamic> jsonMap = jsonDecode(jsonStr);
    return UserProfileModel(identifier: jsonMap['identifier'], passwordHash: jsonMap['passwordHash']);
  }

  /// Returns a Json string based on the model properties.
  String toJson() {
    return jsonEncode({"identifier": super.identifier, "passwordHash": super.passwordHash});
  }
}
