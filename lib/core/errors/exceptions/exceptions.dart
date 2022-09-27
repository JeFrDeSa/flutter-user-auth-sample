import 'package:equatable/equatable.dart';

/// Abstract class that is inherit by every used exceptions.
/// {@category Exceptions}
abstract class MyExceptions extends Equatable {
  /// The predefined description of the exception cause.
  final String exceptionDetails;

  const MyExceptions({required this.exceptionDetails});
}

/// Defines an exception for issue during a cache read access.
/// {@category Exceptions}
class CacheStorageReadException extends MyExceptions {
  /// Creates an exception with a specific predefined [exceptionDetails] description.
  const CacheStorageReadException()
      : super(exceptionDetails: "[CacheStorageReadException] - Could not read the requested data.");

  @override
  List<Object> get props => [exceptionDetails];
}

/// Defines an exception for issue during a cache write access.
/// {@category Exceptions}
class CacheStorageWriteException extends MyExceptions {
  /// Creates an exception with a specific predefined [exceptionDetails] description.
  const CacheStorageWriteException()
      : super(exceptionDetails: "[CacheStorageWriteException] - Could not write the given data.");

  @override
  List<Object> get props => [exceptionDetails];
}

/// Defines an exception for issue during the deletion of a cached entry.
/// {@category Exceptions}
class CacheStorageDeleteException extends MyExceptions {
  /// Creates an exception with a specific predefined [exceptionDetails] description.
  const CacheStorageDeleteException()
      : super(exceptionDetails: "[CacheStorageDeleteException] - Could not delete the requested data.");

  @override
  List<Object> get props => [exceptionDetails];
}

/// Defines an exception for issue during a database read access.
/// {@category Exceptions}
class DatabaseStorageReadException extends MyExceptions {
  /// Creates an exception with a specific predefined [exceptionDetails] description.
  const DatabaseStorageReadException()
      : super(exceptionDetails: "[DatabaseStorageReadException] - Could not read the requested data.");

  @override
  List<Object> get props => [exceptionDetails];
}

/// Defines an exception for issue during a database write access.
/// {@category Exceptions}
class DatabaseStorageWriteException extends MyExceptions {
  /// Creates an exception with a specific predefined [exceptionDetails] description.
  const DatabaseStorageWriteException()
      : super(exceptionDetails: "[DatabaseStorageWriteException] - Could not write the given data.");

  @override
  List<Object> get props => [exceptionDetails];
}

/// Defines an exception for issue during the deletion of an database entry.
/// {@category Exceptions}
class DatabaseStorageDeleteException extends MyExceptions {
  /// Creates an exception with a specific predefined [exceptionDetails] description.
  const DatabaseStorageDeleteException()
      : super(exceptionDetails: "[DatabaseStorageDeleteException] - Could not delete the requested data.");

  @override
  List<Object> get props => [exceptionDetails];
}

/// Defines an exception in case of the requested data does not exist.
/// {@category Exceptions}
class DataEntryNotFoundException extends MyExceptions {
  /// Creates an exception with a specific predefined [exceptionDetails] description.
  const DataEntryNotFoundException()
      : super(exceptionDetails: "[DataEntryNotFoundException] - No data found for the requested identifier.");

  @override
  List<Object> get props => [exceptionDetails];
}

/// Defines an exception in case of the password verification failed.
/// {@category Exceptions}
class InvalidPasswordException extends MyExceptions {
  /// Creates an exception with a specific predefined [exceptionDetails] description.
  const InvalidPasswordException({required String identifier})
      : super(exceptionDetails: "[InvalidPasswordException] - Password invalid for ID: $identifier.");

  @override
  List<Object> get props => [exceptionDetails];
}

/// Defines an exception in case the current internet connection status is unknown.
/// {@category Exceptions}
class InternetConnectionStatusException extends MyExceptions {
  /// Creates an exception with a specific predefined [exceptionDetails] description.
  const InternetConnectionStatusException()
      : super(exceptionDetails: "[InternetConnectionStatusException] - Could not request the current connection status.");

  @override
  List<Object> get props => [exceptionDetails];
}
