import 'package:meta/meta.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:test/test.dart';

void main() {
  late MyUseCase useCase;

  setUpAll(() {
    useCase = MyUseCase();
  });

  test(
      'Given an error result'
      'When getting the value through when'
      'should return the value of the error function', () {
    final result = useCase(returnError: true);

    final value = result.when(
      (success) => 2,
      (error) => 1,
    );

    expect(value, 1);
  });

  test(
      'Given a success result, '
      'When getting the result though when'
      'should return the value of the success function', () {
    final result = useCase();

    final value = result.when(
      (success) => 2,
      (error) => 1,
    );

    expect(value, 2);
  });

  test(
      'Given a success result, '
      'When getting the result through get, '
      'should return the success value', () {
    final result = useCase();

    MyResult? successResult;
    if (result.isSuccess()) {
      successResult = result.get();
    }

    expect(successResult!.value, isA<String>());
  });

  test('''Given a success result, 
        When getting the result through getSuccess, 
        should return the success value''', () {
    final result = useCase();

    MyResult? successResult;
    if (result.isSuccess()) {
      successResult = result.getSuccess();
    }

    expect(successResult!.value, isA<String>());
  });

  test(''' Given an error result, 
          When getting the result through getSuccess, 
          should return null ''', () {
    final result = useCase(returnError: true);

    MyResult? successResult;
    if (result.isSuccess()) {
      successResult = result.getSuccess();
    }

    expect(successResult?.value, null);
  });

  test(''' Given an error result, 
  When getting the result through the getError, 
  should return the error value
  ''', () {
    final result = useCase(returnError: true);

    MyException? exceptionResult;
    if (result.isError()) {
      exceptionResult = result.getError();
    }

    expect(exceptionResult != null, true);
  });

  test('''
   Given a result of SuccessResult type, 
   when getting the result, 
   should return the success const
  ''', () {
    final result = getMockedSuccessResult();
    expect(result.get(), success);
  });
}

Result<SuccessResult, MyException> getMockedSuccessResult() {
  return Success(success);
}

class MyUseCase {
  Result<MyResult, MyException> call({bool returnError = false}) {
    if (returnError) {
      return Error(MyException('something went wrong'));
    } else {
      return Success(MyResult('nice'));
    }
  }
}

@immutable
class MyException implements Exception {
  final String message;

  MyException(this.message);

  @override
  int get hashCode => message.hashCode;

  @override
  bool operator ==(Object other) => other is MyException && other.message == message;
}

@immutable
class MyResult {
  MyResult(this.value);

  final String value;

  @override
  int get hashCode => value.hashCode;

  @override
  bool operator ==(Object other) => other is MyResult && other.value == value;
}
