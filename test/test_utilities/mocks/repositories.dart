import 'package:u_auth/core/features/user_profile_authentication/domain/repository_contract/user_profile_repository_contract.dart';
import 'package:mockito/annotations.dart';

import 'repositories.mocks.dart';

@GenerateMocks([UserProfileRepositoryContract])
final MockUserProfileRepositoryContract userProfileRepositoryContract = MockUserProfileRepositoryContract();