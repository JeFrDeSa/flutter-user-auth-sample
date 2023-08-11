import 'package:u_auth/core/errors/failures/failures.dart';
import 'package:u_auth/core/features/user_profile_authentication/domain/entities/user_profile.dart';
import 'package:u_auth/core/features/user_profile_authentication/domain/repository_contract/user_profile_repository_contract.dart';
import 'package:u_auth/core/utilities/use_cases_template.dart';
import 'package:u_auth/core/utilities/util.dart' as util;
import 'package:dartz/dartz.dart';

/// Register a new [UserProfile] based on the given user credentials.
/// {@category Use Case}
class RegisterUserProfile extends UseCase<UserProfile, Map<String, String>> {
  /// The interface for the access of stored user profile information.
  final UserProfileRepositoryContract userProfileRepositoryContract;

  /// Creates an use case to create a new user profile during the registration.
  RegisterUserProfile({required this.userProfileRepositoryContract});

  /// Stores the given user credentials into the data storage.
  @override
  Future<Either<MyFailures, UserProfile>> call(Map<String, String> userCredentials) async {
    String passwordHash = util.hashPassword(password: userCredentials['password']!);
    return await userProfileRepositoryContract.storeAuthData(
      identifier: userCredentials['identifier']!,
      passwordHash: passwordHash,
    );
  }
}
