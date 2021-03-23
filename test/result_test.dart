import 'package:multiple_result/result.dart';
import 'package:test/test.dart';

void main() {
  late MyUseCase useCase;

  setUpAll(() {
    useCase = MyUseCase();
  });

  test('Test the when method when the result is an Error', () {
    final result = useCase.call(returnError: true);

    var value = 0;

    result.when((error) => value = 1, (success) => value = 2);

    expect(value, 1);
  });

  test('Test the when method when the result is a Success', () {
    final result = useCase.call();

    var value = 0;

    result.when((error) => value = 1, (success) => value = 2);

    expect(value, 2);
  });

  test('Test the get method for a Success output', () {
    final result = useCase.call();

    MyResult? successResult;
    if (result.isSuccess()) {
      successResult = result.get();
    }

    expect(successResult?.value, "nice");
  });

  test('Test the get method for an Error output but casting a Success output',
      () {
    final result = useCase.call(returnError: true);

    MyResult? successResult;
    if (result.isSuccess()) {
      successResult = result.get();
    }

    expect(successResult?.value, null);
  });

  test('Test the get method for an Error output', () {
    final result = useCase.call(returnError: true);

    MyException? exceptionResult;
    if (result.isError()) {
      exceptionResult = result.get();
    }

    expect(exceptionResult != null, true);
  });
}

class MyUseCase {
  Result<MyException, MyResult> call({bool returnError = false}) {
    if (returnError) {
      return Error(MyException("someting went wrong"));
    } else {
      return Success(MyResult("nice"));
    }
  }
}

class MyException implements Exception {
  MyException(this.message);

  final String message;
}

class MyResult {
  MyResult(this.value);

  final String value;
}
