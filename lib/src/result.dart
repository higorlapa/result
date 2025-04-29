import 'unit.dart' as type_unit;

typedef SuccessCallback<W, S> = W Function(S success);
typedef ErrorCallback<W, E> = W Function(E error);

/// Alias for [Result]
typedef ResultOf<S, E> = Result<S, E>;

/// Base Result class
///
/// Takes two type parameters: [S] for success and [E] for error.
/// Use this class to handle operations that can either succeed or fail.
sealed class Result<S, E> {
  /// Default constructor.
  const Result();

  /// Creates a [Result] that represents a successful operation.
  const factory Result.success(S s) = Success;

  /// Creates a [Result] that represents a failed operation.
  const factory Result.error(E e) = Error;

  /// Gets the success value if this result is a [Success].
  ///
  /// Throws [SuccessResultNotFoundException] if this result is an [Error].
  ///
  /// Make sure to check [isSuccess] or use pattern matching like
  /// `if (result case Success())` before calling this method.
  ///
  /// Alternatively, use [tryGetSuccess] if you're unsure of the result type.
  S getOrThrow();

  /// Returns the success value if available, otherwise null.
  S? tryGetSuccess();

  /// Returns the error value if available, otherwise null.
  E? tryGetError();

  /// Returns true if this result is an [Error].
  bool isError();

  /// Returns true if this result is a [Success].
  bool isSuccess();

  /// Handles both success and error cases with respective callbacks.
  ///
  /// If this result is a success, [whenSuccess] will be called with the success value.
  /// If this result is an error, [whenError] will be called with the error value.
  W when<W>(
    SuccessCallback<W, S> whenSuccess,
    ErrorCallback<W, E> whenError,
  );

  /// Executes [whenSuccess] if this result is a success.
  ///
  /// Returns null if this result is an error.
  R? whenSuccess<R>(
    R Function(S success) whenSuccess,
  );

  /// Executes [whenError] if this result is an error.
  ///
  /// Returns null if this result is a success.
  R? whenError<R>(
    R Function(E error) whenError,
  );
}

/// Success Result.
///
/// Use this class to represent a successful operation with a value of type [S].
final class Success<S, E> extends Result<S, E> {
  /// Creates a Success result with the given value.
  const Success(
    this._success,
  );

  /// Creates a Success result with a Unit value.
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

  /// The success value
  S get success => _success;

  @override
  S getOrThrow() => _success;

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
/// Use this class to represent a failed operation with an error of type [E].
final class Error<S, E> extends Result<S, E> {
  /// Creates an Error result with the given error value.
  const Error(this._error);

  /// Creates an Error result with a Unit value.
  /// ```dart
  /// Error.unit() == Error(unit)
  /// ```
  static Error<S, type_unit.Unit> unit<S>() {
    return Error<S, type_unit.Unit>(type_unit.unit);
  }

  final E _error;

  /// The error value
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
  S getOrThrow() => throw SuccessResultNotFoundException();

  @override
  E tryGetError() => _error;

  @override
  S? tryGetSuccess() => null;

  @override
  R whenError<R>(R Function(E error) whenError) => whenError(_error);

  @override
  R? whenSuccess<R>(R Function(S success) whenSuccess) => null;
}

/// Exception thrown when attempting to access a success value that doesn't exist.
final class SuccessResultNotFoundException<S, E> implements Exception {
  const SuccessResultNotFoundException();

  @override
  String toString() {
    return '''
      Tried to get the success value of [$S], but none was found. 
      Make sure you check [isSuccess] before calling [getOrThrow], or use 
      [tryGetSuccess] if you're unsure of the result type. Alternatively, 
      you can use pattern matching with `if (result case Success())`.
    ''';
  }
}
