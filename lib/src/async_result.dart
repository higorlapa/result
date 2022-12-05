import '../multiple_result.dart';

/// `AsyncResult<S, E>` represents an asynchronous computation.
class AsyncResult<S, E> {
  final Future<Result<S, E>> Function() _run;

  /// Build a [AsyncResult] from a function returning a `Future<Result<S, E>>`.
  AsyncResult(this._run);

  /// Build a [AsyncResult] that returns a [Success].
  factory AsyncResult.success(S success) {
    return Success<S, E>(success).toAsyncResult();
  }

  /// Build a [AsyncResult] that returns a [Error].
  factory AsyncResult.error(E error) {
    return Error<S, E>(error).toAsyncResult();
  }

  /// Run the task and return a `Future<Result<S, E>>`.
  Future<Result<S, E>> run() => _run();

  /// Used to chain multiple functions that return a [AsyncResult].
  /// You can extract the value of every [Success] in the chain without
  /// handling all possible missing cases.
  /// If any of the functions in the chain returns [Error],
  /// the result is [Error].
  AsyncResult<W, E> flatMap<W>(AsyncResult<W, E> Function(S success) fn) {
    return AsyncResult<W, E>(
      () {
        return run().then(
          (result) {
            return result.when(
              (success) => fn(success).run(),
              Error.new,
            );
          },
        );
      },
    );
  }

  /// If the [AsyncResult] is [Success], then change its value from type `S` to
  /// type `W` using function `fn`.
  AsyncResult<W, E> map<W>(W Function(S success) fn) {
    return AsyncResult<W, E>(
      () {
        return run().then((result) => result.map(fn));
      },
    );
  }

  /// If the [AsyncResult] is [Error], then change its value from type `S` to
  /// type `W` using function `fn`.
  AsyncResult<S, W> mapError<W>(W Function(E error) fn) {
    return AsyncResult<S, W>(
      () {
        return run().then((result) => result.mapError(fn));
      },
    );
  }

  /// Change a [Success] value.
  AsyncResult<W, E> pure<W>(W success) {
    return AsyncResult<W, E>(
      () {
        return run().then((result) => result.pure(success));
      },
    );
  }
}
