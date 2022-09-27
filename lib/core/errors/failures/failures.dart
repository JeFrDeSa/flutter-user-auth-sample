import 'package:u_auth/core/errors/exceptions/exceptions.dart';
import 'package:u_auth/core/utilities/constants.dart' as constants;
import 'package:equatable/equatable.dart';

/// Abstract class, which is inherit by the different used failures.
/// {@category Failures}
abstract class MyFailures extends Equatable {
  /// The unique code to identify a failure
  final String failureCode;

  /// The predefined description of the failure cause.
  final String failureMessage;

  /// The underlying exception of the failure.
  final MyExceptions exceptionCause;

  const MyFailures({required this.failureCode, required this.failureMessage, required this.exceptionCause});
}

/// Creates a failure for issues during the [VerifyUserProfile] use case.
/// {@category Failures}
class UserProfileVerificationFailure extends MyFailures {
  /// Creates a failure based on specific predefined parameters and the [exceptionCause].
  /// * A Unique [failureCode]
  /// * The predefined [failureMessage]
  const UserProfileVerificationFailure({required exceptionCause})
      : super(
            failureCode: constants.userProfileVerificationFailureCode,
            failureMessage: "Invalid user login or password!",
            exceptionCause: exceptionCause);

  @override
  List<Object> get props => [failureCode, failureMessage, exceptionCause];
}

/// Creates a failure for issues based on data storage exceptions.
/// * [CacheStorageReadException]
/// * [CacheStorageWriteException]
/// * [CacheStorageDeleteException]
/// * [DatabaseStorageReadException]
/// * [DatabaseStorageWriteException]
/// * [DatabaseStorageDeleteException]
///
/// {@category Failures}
class UserProfileAccessFailure extends MyFailures {
  /// Creates a failure based on specific predefined parameters and the [exceptionCause].
  /// * A Unique [failureCode]
  /// * The predefined [failureMessage]
  const UserProfileAccessFailure({required exceptionCause})
      : super(
            failureCode: constants.userProfileAccessFailureCode,
            failureMessage: "Failed to access the user profile!",
            exceptionCause: exceptionCause);

  @override
  List<Object> get props => [failureCode, failureMessage, exceptionCause];
}
