import 'package:u_auth/core/errors/exceptions/exceptions.dart';
import 'package:u_auth/core/errors/failures/failures.dart';
import 'package:u_auth/core/features/user_profile_authentication/domain/entities/user_profile.dart';
import 'package:u_auth/core/features/user_profile_authentication/domain/repository_contract/user_profile_repository_contract.dart';
import 'package:u_auth/core/utilities/use_cases_template.dart';
import 'package:dartz/dartz.dart';

/// Verifies whether the given login credentials are valid.
/// {@category Use Case}
class VerifyUserProfile extends UseCase<UserProfile, Map<String, String>> {
  /// The interface for the access of stored user profile information.
  final UserProfileRepositoryContract userProfileRepositoryContract;

  /// Creates an use case to verify user profiles login credentials.
  VerifyUserProfile({required this.userProfileRepositoryContract});

  /// Loads the identifier associated user authentication data for the verification from the data storage.
  @override
  Future<Either<MyFailures, UserProfile>> call(Map<String, String> loginCredentials) async {
    Either<MyFailures, UserProfile> loadAuthDataResult;
    loadAuthDataResult = await userProfileRepositoryContract.loadAuthData(identifier: loginCredentials['identifier']!);
    return loadAuthDataResult.fold(
      (failure) {
        return Left(failure);
      },
      (userProfile) {
        String passwordHash = _hashPassword(password: loginCredentials['password']!);
        return _verifyPassword(passwordHash: passwordHash, userProfile: userProfile);
      },
    );
  }

  //ToDo: Move this into core utilities and refactor it for Pbkdf2 class
  String _hashPassword({required String password}) {
    return "${password}Hash";
  }

  /// Returns the user profile of the given login credentials if the verification was successful or a verification failure.
  Either<MyFailures, UserProfile> _verifyPassword({required String passwordHash, required UserProfile userProfile}) {
    if (passwordHash == userProfile.passwordHash) {
      return Right(userProfile);
    } else {
      MyExceptions exceptionCause = InvalidPasswordException(identifier: userProfile.identifier);
      return Left(UserProfileVerificationFailure(exceptionCause: exceptionCause));
    }
  }
}
