import 'package:multiple_result/multiple_result.dart';
import 'package:test/test.dart';

void main() {
  late MyUseCase useCase;

  setUpAll(() {
    useCase = MyUseCase();
  });

  group('factories', () {
    test('Success.unit', () {
      final result = Success.unit();
      expect(result.tryGetSuccess(), unit);
    });

    test('Success.unit type infer', () {
      Result<Unit, Exception> fn() {
        return Success.unit();
      }

      final result = fn();
      expect(result.tryGetSuccess(), unit);
    });

    test('Error.unit', () {
      final result = Error.unit();
      expect(result.tryGetError(), unit);
    });

    test('Error.unit type infer', () {
      Result<String, Unit> fn() {
        return Error.unit();
      }

      final result = fn();
      expect(result.tryGetError(), unit);
    });
  });

  test('Result.success', () {
    final result = Result.success(0);
    expect(result.tryGetSuccess(), 0);
  });

  test('Result.error', () {
    final result = Result.error(0);
    expect(result.tryGetError(), 0);
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

  test('''Given a success result, 
        When getting the result through tryGetSuccess, 
        should return the success value''', () {
    final result = useCase();

    MyResult? successResult;
    if (result.isSuccess()) {
      successResult = result.tryGetSuccess();
    }

    expect(successResult!.value, isA<String>());
    expect(result.isError(), isFalse);
  });

  test(''' Given an error result, 
          When getting the result through tryGetSuccess, 
          should return null ''', () {
    final result = useCase(returnError: true);

    MyResult? successResult;
    if (result.isSuccess()) {
      successResult = result.tryGetSuccess();
    }

    expect(successResult?.value, null);
  });

  test(''' Given an error result, 
  When getting the result through the tryGetError, 
  should return the error value
  ''', () {
    final result = useCase(returnError: true);

    MyException? exceptionResult;
    if (result.isError()) {
      exceptionResult = result.tryGetError();
    }

    expect(exceptionResult != null, true);
    expect(result.isSuccess(), isFalse);
  });

  group(
    "onSuccess and onError",
    () {
      test('''
       Given a result of SuccessResult type, 
       when executing onSuccess, 
       should return the result of onSuccess,
      ''', () {
        final result = Success.unit();
        int? onSuccessValue;
        result.whenSuccess((success) {
          onSuccessValue = 10;
        });
        expect(onSuccessValue, 10);
      });

      test('''
         Given a result of Error type, 
         when executing onSuccess, 
         should return null,
        ''', () {
        final result = useCase.call(returnError: true);
        int? onSuccessValue;
        result.whenSuccess((success) {
          onSuccessValue = 10;
        });
        expect(onSuccessValue, null);
      });

      test('''
       Given a result of SuccessResult type, 
       when executing onError, 
       should return null,
      ''', () {
        final result = Success.unit();
        int? onErrorValue;
        result.whenError((success) {
          onErrorValue = 10;
        });
        expect(onErrorValue, null);
      });

      test('''
         Given a result of an Error type, 
         when executing onError, 
         should return the result of onError,
        ''', () {
        final result = useCase.call(returnError: true);
        int? onErrorValue;
        result.whenError((success) {
          onErrorValue = 10;
        });
        expect(onErrorValue, 10);
      });
    },
  );

  test('equatable', () {
    expect(Success(1) == Success(1), isTrue);
    expect(Success(1).hashCode == Success(1).hashCode, isTrue);

    expect(Error(1) == Error(1), isTrue);
    expect(Error(1).hashCode == Error(1).hashCode, isTrue);
  });
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

class MyException implements Exception {
  final String message;

  MyException(this.message);

  @override
  int get hashCode => message.hashCode;

  @override
  bool operator ==(Object other) =>
      other is MyException && other.message == message;
}

class MyResult {
  MyResult(this.value);

  final String value;

  @override
  int get hashCode => value.hashCode;

  @override
  bool operator ==(Object other) => other is MyResult && other.value == value;
}
