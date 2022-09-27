// ignore_for_file: must_be_immutable

import 'package:u_auth/core/utilities/constants.dart' as constants;
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Defines the user authentication related entity.
/// {@category Entities}
class UserProfile extends Equatable with ChangeNotifier {
  /// The unique identifier.
  final String _identifier;

  /// The hashed password.
  final String _passwordHash;

  /// The availability state of user profile related data.
  constants.UserProfileDataState _dataAvailability;

  /// Creates an entity based on authentication relevant properties.
  UserProfile({
    required identifier,
    required passwordHash,
  })  : _identifier = identifier,
        _passwordHash = passwordHash,
        _dataAvailability = constants.UserProfileDataState.isNotAvailable;

  @override
  List<Object?> get props => [_identifier, _passwordHash];

  String get identifier => _identifier;

  String get passwordHash => _passwordHash;

  /// The availability of [UserProfile] related data.
  constants.UserProfileDataState get dataAvailability => _dataAvailability;

  /// Informs the listeners via [ChangeNotifier] about a change of the availability state.
  void updateDataAvailability(constants.UserProfileDataState availability) {
    _dataAvailability = availability;
    notifyListeners();
  }
}
