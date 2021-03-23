library result;

abstract class Result<E, S> {
  const Result();

  dynamic get();
  bool isError();
  bool isSuccess();

  W when<W>(W Function(E error) whenError, W Function(S success) whenSuccess);
}

class Success<E, S> implements Result<E, S> {
  final S _success;
  const Success(this._success);

  @override
  S get() {
    return _success;
  }

  @override
  bool isError() => false;

  @override
  bool isSuccess() => true;

  @override
  W when<W>(W Function(E error) whenError, W Function(S success) whenSuccess) {
    return whenSuccess(_success);
  }
}

class Error<E, S> implements Result<E, S> {
  final E _error;
  const Error(this._error);

  @override
  E get() {
    return _error;
  }

  @override
  bool isError() => true;

  @override
  bool isSuccess() => false;

  @override
  W when<W>(W Function(E error) whenError, W Function(S succcess) whenSuccess) {
    return whenError(_error);
  }
}
