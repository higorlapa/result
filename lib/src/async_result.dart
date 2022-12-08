import 'dart:async';

import '../multiple_result.dart';

/// `AsyncResult<S, E>` represents an asynchronous computation.
typedef AsyncResult<S, E> = Future<Result<S, E>>;

/// `AsyncResult<S, E>` represents an asynchronous computation.
extension AsyncResultExtension<S, E> on AsyncResult<S, E> {
  /// Returns a new `Result`, mapping any `Success` value
  /// using the given transformation and unwrapping the produced `Result`.
  AsyncResult<W, E> flatMap<W>(FutureOr<Result<W, E>> Function(S success) fn) {
    return then((result) => result.when(fn, Error.new));
  }

  /// Returns a new `Result`, mapping any `Error` value
  /// using the given transformation and unwrapping the produced `Result`.
  AsyncResult<S, W> flatMapError<W>(
      FutureOr<Result<S, W>> Function(E error) fn) {
    return then((result) => result.when(Success.new, fn));
  }

  /// Returns a new `AsyncResult`, mapping any `Success` value
  /// using the given transformation.
  AsyncResult<W, E> map<W>(W Function(S success) fn) {
    return then((result) => result.map(fn));
  }

  /// Returns a new `Result`, mapping any `Error` value
  /// using the given transformation.
  AsyncResult<S, W> mapError<W>(W Function(E error) fn) {
    return then((result) => result.mapError(fn));
  }

  /// Change a [Success] value.
  AsyncResult<W, E> pure<W>(W success) {
    return then((result) => result.pure(success));
  }

  /// Change the [Error] value.
  AsyncResult<S, W> pureError<W>(W error) {
    return mapError((_) => error);
  }

  /// Swap the values contained inside the [Success] and [Error]
  /// of this [AsyncResult].
  AsyncResult<E, S> swap() {
    return then((result) => result.swap());
  }
}
