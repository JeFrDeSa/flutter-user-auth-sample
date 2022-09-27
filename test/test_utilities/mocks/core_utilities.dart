import 'package:u_auth/core/utilities//network_service/network_service_contract.dart';
import 'package:u_auth/core/utilities/cache_storage/cache_storage_contract.dart';
import 'package:u_auth/core/utilities/database_storage/database_storage_contract.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core_utilities.mocks.dart';

@GenerateMocks([NetworkServiceContract])
final MockNetworkServiceContract networkService = MockNetworkServiceContract();

@GenerateMocks([InternetConnectionChecker])
final MockInternetConnectionChecker internetConnectionChecker = MockInternetConnectionChecker();

@GenerateMocks([CacheStorageContract])
final MockCacheStorageContract cacheStorage = MockCacheStorageContract();

@GenerateMocks([DatabaseStorageContract])
final MockDatabaseStorageContract databaseStorage = MockDatabaseStorageContract();

@GenerateMocks([SharedPreferences])
final MockSharedPreferences sharedPreferences = MockSharedPreferences();