import 'unit.dart' as type_unit;

typedef SuccessCallback<W, S> = W Function(S success);
typedef ErrorCallback<W, E> = W Function(E error);

/// Alias for [Result]
typedef ResultOf<S, E> = Result<S, E>;

/// Base Result class
///
/// Receives two values [E] and [S]
/// as [E] is an error and [S] is a success.
sealed class Result<S, E> {
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

  /// Handle the result when success or error
  ///
  /// if the result is an error, it will be returned in [whenError]
  /// if it is a success it will be returned in [whenSuccess]
  W when<W>(
    SuccessCallback<W, S> whenSuccess,
    ErrorCallback<W, E> whenError,
  );

  /// Execute [whenSuccess] if the [Result] is a success.
  R? whenSuccess<R>(
    R Function(S success) whenSuccess,
  );

  /// Execute [whenError] if the [Result] is an error.
  R? whenError<R>(
    R Function(E error) whenError,
  );
}

/// Success Result.
///
/// return it when the result of a [Result] is
/// the expected value.
final class Success<S, E> extends Result<S, E> {
  /// Receives the [S] param as
  /// the successful result.
  const Success(
    this._success,
  );

  /// Build a `Success` with `Unit` value.
  /// ```dart
  /// Success.unit() == Success(unit)
  /// ```
  static Success<type_unit.Unit, E> unit<E>() {
    return Success<type_unit.Unit, E>(type_unit.unit);
  }

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
    SuccessCallback<W, S> whenSuccess,
    ErrorCallback<W, E> whenError,
  ) =>
      whenSuccess(_success);

  /// Success value
  S get success => _success;

  @override
  E? tryGetError() => null;

  @override
  S tryGetSuccess() => _success;

  @override
  R? whenError<R>(R Function(E error) whenError) => null;

  @override
  R whenSuccess<R>(R Function(S success) whenSuccess) {
    return whenSuccess(_success);
  }
}

/// Error Result.
///
/// return it when the result of a [Result] is
/// not the expected value.
final class Error<S, E> extends Result<S, E> {
  /// Receives the [E] param as
  /// the error result.
  const Error(this._error);

  /// Build a `Error` with `Unit` value.
  /// ```dart
  /// Error.unit() == Error(unit)
  /// ```
  static Error<S, type_unit.Unit> unit<S>() {
    return Error<S, type_unit.Unit>(type_unit.unit);
  }

  final E _error;

  /// Error value
  E get error => _error;

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
    SuccessCallback<W, S> whenSuccess,
    ErrorCallback<W, E> whenError,
  ) =>
      whenError(_error);

  @override
  E tryGetError() => _error;

  @override
  S? tryGetSuccess() => null;

  @override
  R whenError<R>(R Function(E error) whenError) => whenError(_error);

  @override
  R? whenSuccess<R>(R Function(S success) whenSuccess) => null;
}
