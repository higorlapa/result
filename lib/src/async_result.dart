import 'result.dart';

/// A zero-cost wrapper around [Future<Result<S, E>>] using Dart extension types.
///
/// [AsyncResult] lets you chain and transform asynchronous [Result] values
/// using the same API as synchronous [Result], without allocating any
/// intermediate wrapper objects at runtime.
///
/// Example:
/// ```dart
/// AsyncResult<String, Exception> fetchUser(int id) =>
///     AsyncResult(fetchUserJson(id).then((json) => Success(json['name'])));
///
/// final name = await fetchUser(42)
///     .mapSuccess((n) => n.toUpperCase())
///     .getOrElse((_) => 'unknown');
/// ```
extension type AsyncResult<S, E>(Future<Result<S, E>> _future) {
  /// Returns the inner [Future<Result<S, E>>].
  Future<Result<S, E>> get future => _future;

  // ── Transformations ─────────────────────────────────────────────────────────

  /// Transforms the success value if this resolves to a [Success].
  AsyncResult<U, E> mapSuccess<U>(U Function(S success) mapper) =>
      AsyncResult(_future.then((r) => r.mapSuccess(mapper)));

  /// Transforms the error value if this resolves to an [Error].
  AsyncResult<S, F> mapError<F>(F Function(E error) mapper) =>
      AsyncResult(_future.then((r) => r.mapError(mapper)));

  /// Transforms both success and error values.
  AsyncResult<U, F> map<U, F>({
    required U Function(S success) successMapper,
    required F Function(E error) errorMapper,
  }) =>
      AsyncResult(
        _future.then(
          (r) => r.map(successMapper: successMapper, errorMapper: errorMapper),
        ),
      );

  /// Chains an operation that returns a synchronous [Result].
  AsyncResult<U, E> flatMap<U>(Result<U, E> Function(S success) mapper) =>
      AsyncResult(_future.then((r) => r.flatMap(mapper)));

  /// Chains an operation that returns an [AsyncResult].
  AsyncResult<U, E> flatMapAsync<U>(
    AsyncResult<U, E> Function(S success) mapper,
  ) =>
      AsyncResult(
        _future.then(
          (r) => switch (r) {
            Success(:final success) => mapper(success)._future,
            Error(:final error) => Future.value(Result<U, E>.error(error)),
          },
        ),
      );

  /// Chains error recovery that returns a synchronous [Result].
  AsyncResult<S, F> flatMapError<F>(
    Result<S, F> Function(E error) mapper,
  ) =>
      AsyncResult(_future.then((r) => r.flatMapError(mapper)));

  /// Returns a new [AsyncResult] with [Success] and [Error] swapped.
  AsyncResult<E, S> swap() => AsyncResult(_future.then((r) => r.swap()));

  // ── Side effects ────────────────────────────────────────────────────────────

  /// Executes [action] as a side effect if the result is a [Success],
  /// then propagates the result unchanged.
  AsyncResult<S, E> onSuccess(void Function(S success) action) =>
      AsyncResult(_future.then((r) => r.onSuccess(action)));

  /// Executes [action] as a side effect if the result is an [Error],
  /// then propagates the result unchanged.
  AsyncResult<S, E> onError(void Function(E error) action) =>
      AsyncResult(_future.then((r) => r.onError(action)));

  // ── Extraction ──────────────────────────────────────────────────────────────

  /// Awaits the result and returns the success value, or throws
  /// [SuccessResultNotFoundException] if it is an [Error].
  Future<S> getOrThrow() => _future.then((r) => r.getOrThrow());

  /// Awaits the result and returns the success value, or calls [orElse] with
  /// the error and returns that value.
  Future<S> getOrElse(S Function(E error) orElse) =>
      _future.then((r) => r.getOrElse(orElse));

  /// Awaits the result and returns the success value, or null.
  Future<S?> tryGetSuccess() => _future.then((r) => r.tryGetSuccess());

  /// Awaits the result and returns the error value, or null.
  Future<E?> tryGetError() => _future.then((r) => r.tryGetError());

  /// Awaits and calls [whenSuccess] or [whenError] based on the result.
  Future<W> when<W>(
    W Function(S success) whenSuccess,
    W Function(E error) whenError,
  ) =>
      _future.then((r) => r.when(whenSuccess, whenError));

  /// Awaits and checks whether the result is a [Success].
  Future<bool> isSuccess() => _future.then((r) => r.isSuccess());

  /// Awaits and checks whether the result is an [Error].
  Future<bool> isError() => _future.then((r) => r.isError());

  // ── Factory ─────────────────────────────────────────────────────────────────

  /// Wraps a potentially-throwing async operation.
  ///
  /// If [action] completes normally, returns an [AsyncResult] wrapping [Success].
  /// If [action] throws, calls [onError] and returns an [AsyncResult] wrapping [Error].
  ///
  /// Example:
  /// ```dart
  /// final result = AsyncResult.tryCatch(
  ///   () async => await fetchUser(id),
  ///   (err, stack) => NetworkError(err.toString()),
  /// );
  /// ```
  static AsyncResult<S, E> tryCatch<S, E>(
    Future<S> Function() action,
    E Function(Object error, StackTrace stackTrace) onError,
  ) =>
      AsyncResult(
        Future(() async {
          try {
            return Success<S, E>(await action());
          } catch (e, s) {
            return Error<S, E>(onError(e, s));
          }
        }),
      );
}

/// Alias for [AsyncResult].
typedef AsyncResultOf<S, E> = AsyncResult<S, E>;
