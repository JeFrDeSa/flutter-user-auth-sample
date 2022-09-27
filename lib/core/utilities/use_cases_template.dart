import 'package:dartz/dartz.dart';
import 'package:u_auth/core/errors/failures/failures.dart';

/// Abstract class, which is inherit by the different use cases.
///
/// Requires a return [Type] of the value that is returned after a successfully execution and the
/// definition of the accepted type of [Param]eters. Returns a failure of base type [MyFailures]
/// after an unsuccessful execution.
/// {@category Use Cases}
abstract class UseCase<Type, Param> {
  /// The standard interface for use cases.
  Future<Either<MyFailures, Type>> call(Param param);
}