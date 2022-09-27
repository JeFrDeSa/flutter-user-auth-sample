// coverage:ignore-file

import 'package:u_auth/core/features/user_profile_authentication/data/repository/user_profile_repository.dart';
import 'package:u_auth/core/features/user_profile_authentication/domain/repository_contract/user_profile_repository_contract.dart';
import 'package:u_auth/core/features/user_profile_authentication/domain/use_cases/login_user_profile.dart';
import 'package:u_auth/core/features/user_profile_authentication/domain/use_cases/register_user_profile.dart';
import 'package:u_auth/core/features/user_profile_authentication/domain/use_cases/verify_user_profile.dart';
import 'package:u_auth/core/features/user_profile_authentication/presentation/bloc_user_profile_authentication/user_profile_authentication_bloc.dart';
import 'package:u_auth/core/utilities/cache_storage/cache_storage.dart';
import 'package:u_auth/core/utilities/cache_storage/cache_storage_contract.dart';
import 'package:u_auth/core/utilities/database_storage/database_storage.dart';
import 'package:u_auth/core/utilities/database_storage/database_storage_contract.dart';
import 'package:u_auth/core/utilities/network_service/network_service.dart';
import 'package:u_auth/core/utilities/network_service/network_service_contract.dart';
import 'package:u_auth/core/utilities/user_notification/bloc_user_notification/user_notification_dialog_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The Singleton instance of [GetIt]
final serviceLocator = GetIt.instance;

/// Initialize the by the application service Locator registered services.
Future<void> init() async {
  // Application BloC Factory
  serviceLocator.registerFactory(() => UserNotificationDialogBloc());
  serviceLocator.registerFactory(() => UserProfileAuthenticationBloc(
        useCaseVerifyUserProfile: serviceLocator(),
        useCaseLoginUserProfile: serviceLocator(),
        useCaseRegisterUserProfile: serviceLocator(),
      ));

  // Application Use Cases
  serviceLocator.registerLazySingleton(() => VerifyUserProfile(userProfileRepositoryContract: serviceLocator()));
  serviceLocator.registerLazySingleton(() => LoginUserProfile(userProfileRepositoryContract: serviceLocator()));
  serviceLocator.registerLazySingleton(() => RegisterUserProfile(userProfileRepositoryContract: serviceLocator()));

  // Application Repository
  serviceLocator.registerLazySingleton<UserProfileRepositoryContract>(
    () => UserProfileRepository(
        databaseStorageContract: serviceLocator(),
        cacheStorageContract: serviceLocator(),
        networkServiceContract: serviceLocator()),
  );

  // Application Data sources
  serviceLocator.registerLazySingleton<DatabaseStorageContract>(() => DatabaseStorage());
  serviceLocator.registerLazySingleton<CacheStorageContract>(() => CacheStorage(serviceLocator()));
  serviceLocator.registerLazySingleton<NetworkServiceContract>(() => NetworkService(serviceLocator()));

  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(() => sharedPreferences);
  serviceLocator.registerLazySingleton(() => InternetConnectionChecker());
}
