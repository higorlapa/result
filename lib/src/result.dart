import 'package:meta/meta.dart';

import 'async_result.dart';

/// Base Result class
///
/// Receives two values [E] and [S]
/// as [E] is an error and [S] is a success.
@sealed
abstract class Result<S, E> {
  /// Default constructor.
  const Result();

  /// Build a [Result] that returns a [Error].
  factory Result.success(S s) => Success(s);

  /// Build a [Result] that returns a [Error].
  factory Result.error(E e) => Error(e);

  /// Returns the value of [S] if any.
  S? tryGetSuccess();

  /// Returns the value of [E] if any.
  E? tryGetError();

  /// Returns true if the current result is an [Error].
  bool isError();

  /// Returns true if the current result is a [Success].
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

  /// If the [Result] is [Success], then change its value from type `S` to
  /// type `W` using function `fn`.
  Result<W, E> map<W>(W Function(S success) fn) {
    return when((success) => Success(fn(success)), Error.new);
  }

  /// If the [Result] is [Error], then change its value from type `S` to
  /// type `W` using function `fn`.
  Result<S, W> mapError<W>(W Function(E error) fn) {
    return when(Success.new, (error) => Error(fn(error)));
  }

  /// Used to chain multiple functions that return a [Result].
  /// You can extract the value of every [Success] in the chain without
  /// handling all possible missing cases.
  /// If any of the functions in the chain returns [Error],
  /// the result is [Error].
  Result<W, E> flatMap<W>(Result<W, E> Function(S success) fn);

  /// Change a [Success] value.
  Result<W, E> pure<W>(W success) {
    return map((_) => success);
  }

  /// Return a [AsyncResult].
  AsyncResult<S, E> toAsyncResult() async => this;
}

/// Success Result.
///
/// return it when the result of a [Result] is
/// the expected value.
@immutable
class Success<S, E> extends Result<S, E> {
  /// Receives the [S] param as
  /// the successful result.
  const Success(
    this._success,
  );

  final S _success;

  @override
  bool isError() => false;

  @override
  bool isSuccess() => true;

  @override
  int get hashCode => _success.hashCode;

  @override
  bool operator ==(Object other) {
    return other is Success && other._success == _success;
  }

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

  @override
  Result<W, E> flatMap<W>(Result<W, E> Function(S success) fn) {
    return fn(_success);
  }
}

/// Error Result.
///
/// return it when the result of a [Result] is
/// not the expected value.
@immutable
class Error<S, E> extends Result<S, E> {
  /// Receives the [E] param as
  /// the error result.
  const Error(this._error);

  final E _error;

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

  @override
  Result<W, E> flatMap<W>(Result<W, E> Function(S success) fn) {
    return Error<W, E>(_error);
  }
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
@Deprecated('Use Unit instead.')
class SuccessResult {
  const SuccessResult._internal();
}

/// Default success case.
@Deprecated('Use unit instead.')
const success = SuccessResult._internal();
