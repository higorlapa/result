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

  group("getOrThrow", () {
    test(
        "When accessing `getOrThrow` with a Success result, should return the Success value",
        () {
      final result = useCase.call();

      expect(result.getOrThrow(), isA<MyResult>());
    });

    test(
        "When accessing `getOrThrow` with a Error result, should throw SuccessResultNotFoundException",
        () {
      final result = useCase.call(returnError: true);

      expect(
        () => result.getOrThrow(),
        throwsA(
          isA<SuccessResultNotFoundException>(),
        ),
      );
    });
  });

  group('getBoth method', () {
    test('when result is Success, returns success value and null error', () {
      final result = Result.success('test');
      final record = result.getBoth();

      expect(record.success, 'test');
      expect(record.error, null);
    });

    test('when result is Error, returns null success and error value', () {
      final error = Exception('test error');
      final result = Result.error(error);
      final record = result.getBoth();

      expect(record.success, null);
      expect(record.error, error);
    });

    test('can destructure with record pattern', () {
      final result = Result.success('test');
      final (:success, :error) = result.getBoth();

      expect(success, 'test');
      expect(error, null);
    });
  });

  group('map method', () {
    test('applies successMapper to a Success result', () {
      final result = Result.success(5);
      final mapped = result.map(
        successMapper: (value) => value.toString(),
        errorMapper: (error) => 'error: $error',
      );

      expect(mapped, Success('5'));
    });

    test('applies errorMapper to an Error result', () {
      final error = Exception('test error');
      final result = Result.error(error);
      final mapped = result.map(
        successMapper: (value) => value.toString(),
        errorMapper: (error) => 'error: $error',
      );

      expect(mapped, Error('error: $error'));
    });

    test('supports different return types for both mappers', () {
      final result = Result.success(5);
      final mapped = result.map<String, bool>(
        successMapper: (value) => value.toString(),
        errorMapper: (error) => false,
      );

      expect(mapped, Success('5'));
      expect(mapped, isA<Result<String, bool>>());
    });
  });

  group('mapSuccess method', () {
    test('transforms success value in a Success result', () {
      final result = Result.success(5);
      final mapped = result.mapSuccess((value) => value * 2);

      expect(mapped, Success(10));
    });

    test('preserves Error in an Error result', () {
      final error = Exception('test error');
      final result = Result.error(error);
      final mapped = result.mapSuccess((value) => value.toString());

      expect(mapped, Error(error));
    });

    test('supports changing success type', () {
      final result = Result.success(5);
      final mapped = result.mapSuccess((value) => value.toString());

      expect(mapped, Success('5'));
      expect(mapped, isA<Success>());
    });
  });

  group('mapError method', () {
    test('preserves Success in a Success result', () {
      final result = Result.success(5);
      final mapped = result.mapError((error) => 'error: $error');

      expect(mapped, Success(5));
    });

    test('transforms error value in an Error result', () {
      final error = Exception('test error');
      final result = Result.error(error);
      final mapped = result.mapError((error) => error.toString());

      expect(mapped, Error(error.toString()));
    });

    test('supports changing error type', () {
      final error = Exception('test error');
      final result = Result.error(error);
      final mapped = result.mapError((error) => 42);

      expect(mapped, Error(42));
      expect(mapped, isA<Error>());
    });
  });

  group('flatMap method', () {
    test('allows chaining operations that return a Result', () {
      final result = Result.success(5);
      final transformed =
          result.flatMap((value) => Result.success(value.toString()));

      expect(transformed, Success('5'));
    });

    test('short-circuits on Error', () {
      final error = Exception('test error');
      final result = Result.error(error);
      final transformed =
          result.flatMap((value) => Result.success(value.toString()));

      expect(transformed, Error(error));
    });

    test('propagates errors from the mapper function', () {
      final result = Result.success(5);
      final transformed = result.flatMap<String>((value) => value > 10
          ? Result.success(value.toString())
          : Result.error('Value too small'));

      expect(transformed, Error('Value too small'));
    });

    test('can be chained multiple times', () {
      int parseToInt(String input) {
        final value = int.tryParse(input);
        if (value == null) {
          throw FormatException('Cannot parse $input');
        }
        return value;
      }

      // Function that might fail
      Result<int, String> parseInt(String input) {
        try {
          return Result.success(parseToInt(input));
        } catch (e) {
          return Result.error(e.toString());
        }
      }

      // Function that might fail
      Result<String, String> doubleIt(int value) {
        if (value < 0) {
          return Result.error('Cannot double negative numbers');
        }
        return Result.success((value * 2).toString());
      }

      final result = parseInt('5').flatMap((value) => doubleIt(value));

      expect(result, Success('10'));

      final resultWithFirstError =
          parseInt('abc').flatMap((value) => doubleIt(value));

      expect(resultWithFirstError.isError(), true);
      expect(resultWithFirstError.tryGetError(), contains('FormatException'));

      final resultWithSecondError =
          parseInt('-5').flatMap((value) => doubleIt(value));

      expect(resultWithSecondError.isError(), true);
      expect(resultWithSecondError.tryGetError(),
          'Cannot double negative numbers');
    });

    test('flatMap can be used for conditional logic', () {
      // Instead of chaining, just test the basic functionality
      final initialResult = Result<int, String>.success(5);

      // Convert int to string
      final stringResult = initialResult.flatMap<String>(
          (int value) => Result<String, String>.success(value.toString()));

      expect(stringResult, Success('5'));
    });

    test('flatMap with error result short-circuits', () {
      final initialResult = Result<int, String>.error('Initial error');

      bool wasCalled = false;
      final transformedResult = initialResult.flatMap<String>((value) {
        wasCalled = true;
        return Result<String, String>.success(value.toString());
      });

      expect(wasCalled, false); // The mapper function should not be called
      expect(transformedResult.isError(), true);
      expect(transformedResult.tryGetError(), 'Initial error');
    });
  });

  group('comparison with when method', () {
    test('map can replace when for simple transformations', () {
      final result = Result.success(10);

      // Traditional when approach
      final value1 = result.when(
        (success) => success * 2,
        (error) => -1,
      );

      // Using map approach
      final value2 = result
              .map(
                successMapper: (success) => success * 2,
                errorMapper: (error) => -1,
              )
              .tryGetSuccess() ??
          -1;

      expect(value1, value2);
    });
  });

  newMethodTests();
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

// ── New method tests ─────────────────────────────────────────────────────────

void newMethodTests() {
  group('getOrElse', () {
    test('returns success value on Success', () {
      final result = Result<int, String>.success(42);
      expect(result.getOrElse((_) => -1), 42);
    });

    test('returns fallback computed from error on Error', () {
      final result = Result<int, String>.error('oops');
      expect(result.getOrElse((e) => e.length), 4);
    });

    test('fallback is not called on Success', () {
      bool called = false;
      Result<int, String>.success(1).getOrElse((e) {
        called = true;
        return -1;
      });
      expect(called, isFalse);
    });
  });

  group('onSuccess', () {
    test('executes action and returns same instance on Success', () {
      final result = Result<int, String>.success(10);
      int? captured;
      final returned = result.onSuccess((v) => captured = v);
      expect(captured, 10);
      expect(identical(returned, result), isTrue);
    });

    test('does not execute action and returns same instance on Error', () {
      final result = Result<int, String>.error('err');
      bool called = false;
      final returned = result.onSuccess((_) => called = true);
      expect(called, isFalse);
      expect(identical(returned, result), isTrue);
    });

    test('can be chained', () {
      final log = <String>[];
      Result<String, int>.success('a')
          .onSuccess((v) => log.add('first: $v'))
          .onSuccess((v) => log.add('second: $v'));
      expect(log, ['first: a', 'second: a']);
    });
  });

  group('onError', () {
    test('executes action and returns same instance on Error', () {
      final result = Result<int, String>.error('bad');
      String? captured;
      final returned = result.onError((e) => captured = e);
      expect(captured, 'bad');
      expect(identical(returned, result), isTrue);
    });

    test('does not execute action and returns same instance on Success', () {
      final result = Result<int, String>.success(1);
      bool called = false;
      final returned = result.onError((_) => called = true);
      expect(called, isFalse);
      expect(identical(returned, result), isTrue);
    });
  });

  group('flatMapError / recover', () {
    test('flatMapError transforms Error to new Result', () {
      final result = Result<int, String>.error('not found');
      final recovered =
          result.flatMapError((e) => Result<int, int>.success(0));
      expect(recovered, const Success<int, int>(0));
    });

    test('flatMapError is a no-op on Success', () {
      final result = Result<int, String>.success(5);
      bool called = false;
      final out = result.flatMapError((e) {
        called = true;
        return Result<int, int>.success(0);
      });
      expect(called, isFalse);
      expect(out, const Success<int, int>(5));
    });

    test('flatMapError can propagate a different error type', () {
      final result = Result<int, String>.error('msg');
      final out =
          result.flatMapError((e) => Result<int, int>.error(e.length));
      expect(out, const Error<int, int>(3));
    });

    test('recover is an alias for flatMapError', () {
      final result = Result<int, String>.error('fail');
      final out = result.recover((e) => Result<int, int>.success(99));
      expect(out, const Success<int, int>(99));
    });
  });

  group('swap', () {
    test('Success becomes Error with the same value', () {
      final result = Result<String, int>.success('hello');
      final swapped = result.swap();
      expect(swapped, isA<Error<int, String>>());
      expect(swapped.tryGetError(), 'hello');
    });

    test('Error becomes Success with the same value', () {
      final result = Result<String, int>.error(42);
      final swapped = result.swap();
      expect(swapped, isA<Success<int, String>>());
      expect(swapped.tryGetSuccess(), 42);
    });

    test('double swap returns equivalent result', () {
      final original = Result<String, int>.success('x');
      expect(original.swap().swap(), const Success<String, int>('x'));
    });
  });

  group('Result.tryCatch', () {
    test('wraps a successful computation in Success', () {
      final result = Result.tryCatch(
        () => int.parse('42'),
        (e, s) => 'parse error: $e',
      );
      expect(result, const Success<int, String>(42));
    });

    test('wraps a thrown exception in Error', () {
      final result = Result.tryCatch(
        () => int.parse('abc'),
        (e, s) => 'failed',
      );
      expect(result, const Error<int, String>('failed'));
    });

    test('onError callback receives the exception and stack trace', () {
      Object? caught;
      StackTrace? caughtStack;
      Result.tryCatch(
        () => throw StateError('boom'),
        (e, s) {
          caught = e;
          caughtStack = s;
          return 'err';
        },
      );
      expect(caught, isA<StateError>());
      expect(caughtStack, isNotNull);
    });
  });

  group('SuccessResultNotFoundException type parameters', () {
    test('toString includes the actual success type', () {
      final result = Result<String, int>.error(0);
      try {
        result.getOrThrow();
        fail('Should have thrown');
      } on SuccessResultNotFoundException<String, int> catch (e) {
        expect(e.toString(), contains('String'));
      }
    });
  });
}
