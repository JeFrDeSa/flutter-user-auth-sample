import 'package:dartz/dartz.dart';
import 'package:u_auth/core/errors/failures/failures.dart';
import 'package:u_auth/core/features/user_profile_authentication/domain/repository_contract/user_profile_repository_contract.dart';
import 'package:u_auth/core/utilities/use_cases_template.dart';
import 'package:u_auth/core/utilities/constants.dart';

/// Requests all [UserProfile] related data from the data storage.
/// {@category Use Case}
class LoginUserProfile extends UseCase<NoParams, NoParams> {
  /// The interface for the access of stored user profile information.
  final UserProfileRepositoryContract userProfileRepositoryContract;

  /// Creates an use case to preload stored user profile related data during login.
  LoginUserProfile({required this.userProfileRepositoryContract});

  /// Executes the preloading of the loaded user profile related data.
  @override
  Future<Either<MyFailures, NoParams>> call(NoParams noParams) async {
    return await userProfileRepositoryContract.preloadUserProfileData();
  }
}