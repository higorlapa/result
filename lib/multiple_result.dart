library multiple_result;

import 'package:meta/meta.dart';

/// Base Result class
///
/// Receives two values [E] and [S]
/// as [E] is an error and [S] is a success.
@sealed
abstract class Result<S, E> {
  /// Default constructor.
  const Result();

  /// Returns the current result.
  ///
  /// It may be a [Success] or an [Error].
  /// Check with
  /// ```dart
  ///   result.isSuccess();
  /// ```
  /// or
  /// ```dart
  ///   result.isError();
  /// ```
  ///
  /// before casting the value;
  @Deprecated('Will be removed in the next version. '
      'Use `tryGetSuccess` or `tryGetError` instead.'
      'You may also use `onSuccess` and on `onError` for similar result.')
  dynamic get();

  /// Returns the value of [S] if any.
  S? tryGetSuccess();

  /// Returns the value of [E] if any.
  E? tryGetError();

  /// Returns true if the current result is an [Error].
  bool isError();

  /// Returns true if the current result is a [success].
  bool isSuccess();

  /// Return the result in one of these functions.
  ///
  /// if the result is an error, it will be returned in
  /// [whenError],
  /// if it is a success it will be returned in [whenSuccess].
  W when<W>(
    W Function(S success) whenSuccess,
    W Function(E error) whenError,
  );

  /// Execute [whenSuccess] if the [Result] is a success.
  R? onSuccess<R>(
    R Function(S success) whenSuccess,
  );

  /// Execute [whenError] if the [Result] is an error.
  R? onError<R>(
    R Function(E error) whenError,
  );
}

/// Success Result.
///
/// return it when the result of a [Result] is
/// the expected value.
@immutable
class Success<S, E> implements Result<S, E> {
  /// Receives the [S] param as
  /// the successful result.
  const Success(
    this._success,
  );

  final S _success;

  @override
  S get() {
    return _success;
  }

  @override
  bool isError() => false;

  @override
  bool isSuccess() => true;

  @override
  int get hashCode => _success.hashCode;

  @override
  bool operator ==(Object other) =>
      other is Success && other._success == _success;

  @override
  W when<W>(
    W Function(S success) whenSuccess,
    W Function(E error) whenError,
  ) {
    return whenSuccess(_success);
  }

  @override
  E? tryGetError() => null;

  @override
  S tryGetSuccess() => _success;

  @override
  R? onError<R>(R Function(E error) whenError) => null;

  @override
  R onSuccess<R>(R Function(S success) whenSuccess) {
    return whenSuccess(_success);
  }
}

/// Error Result.
///
/// return it when the result of a [Result] is
/// not the expected value.
@immutable
class Error<S, E> implements Result<S, E> {
  /// Receives the [E] param as
  /// the error result.
  const Error(this._error);

  final E _error;

  @override
  E get() {
    return _error;
  }

  @override
  bool isError() => true;

  @override
  bool isSuccess() => false;

  @override
  int get hashCode => _error.hashCode;

  @override
  bool operator ==(Object other) => other is Error && other._error == _error;

  @override
  W when<W>(
    W Function(S succcess) whenSuccess,
    W Function(E error) whenError,
  ) {
    return whenError(_error);
  }

  @override
  E tryGetError() => _error;

  @override
  S? tryGetSuccess() => null;

  @override
  R onError<R>(R Function(E error) whenError) => whenError(_error);

  @override
  R? onSuccess<R>(R Function(S success) whenSuccess) => null;

}

/// Default success class.
///
/// Instead of returning void, as
/// ```dart
///   Result<void, Exception>
/// ```
/// return
/// ```dart
///   Result<SuccessResult, Exception>
/// ```
class SuccessResult {
  const SuccessResult._internal();
}

/// Default success case.
const success = SuccessResult._internal();


