import 'package:u_auth/core/features/user_profile_authentication/domain/use_cases/login_user_profile.dart';
import 'package:u_auth/core/features/user_profile_authentication/domain/use_cases/register_user_profile.dart';
import 'package:u_auth/core/features/user_profile_authentication/domain/use_cases/verify_user_profile.dart';
import 'package:mockito/annotations.dart';

import 'use_cases.mocks.dart';

@GenerateMocks([VerifyUserProfile])
final MockVerifyUserProfile verifyUserProfile = MockVerifyUserProfile();

@GenerateMocks([LoginUserProfile])
final MockLoginUserProfile loginUserProfile = MockLoginUserProfile();

@GenerateMocks([RegisterUserProfile])
final MockRegisterUserProfile registerUserProfile = MockRegisterUserProfile();