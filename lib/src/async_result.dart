import '../multiple_result.dart';

/// `AsyncResult<S, E>` represents an asynchronous computation.
typedef AsyncResult<S, E> = Future<Result<S, E>>;

/// `AsyncResult<S, E>` represents an asynchronous computation.
extension AsyncResultExtension<S, E> on AsyncResult<S, E> {
  /// Used to chain multiple functions that return a [AsyncResult].
  /// You can extract the value of every [Success] in the chain without
  /// handling all possible missing cases.
  /// If any of the functions in the chain returns [Error],
  /// the result is [Error].
  AsyncResult<W, E> flatMap<W>(AsyncResult<W, E> Function(S success) fn) {
    return then((result) => result.when(fn, Error.new));
  }

  /// If the [AsyncResult] is [Success], then change its value from type `S` to
  /// type `W` using function `fn`.
  AsyncResult<W, E> map<W>(W Function(S success) fn) {
    return then((result) => result.map(fn));
  }

  /// If the [AsyncResult] is [Error], then change its value from type `S` to
  /// type `W` using function `fn`.
  AsyncResult<S, W> mapError<W>(W Function(E error) fn) {
    return then((result) => result.mapError(fn));
  }

  /// Change a [Success] value.
  AsyncResult<W, E> pure<W>(W success) {
    return then((result) => result.pure(success));
  }
}
