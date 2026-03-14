import 'package:multiple_result/multiple_result.dart';
import 'package:test/test.dart';

void main() {
  group('AsyncResult.mapSuccess', () {
    test('transforms success value', () async {
      final ar = AsyncResult(Future.value(Result<int, String>.success(5)));
      expect(await ar.mapSuccess((v) => v * 2).tryGetSuccess(), 10);
    });

    test('preserves error', () async {
      final ar = AsyncResult(Future.value(Result<int, String>.error('e')));
      final mapped = ar.mapSuccess((v) => v * 2);
      expect(await mapped.tryGetSuccess(), isNull);
      expect(await mapped.tryGetError(), 'e');
    });
  });

  group('AsyncResult.mapError', () {
    test('transforms error value', () async {
      final ar = AsyncResult(Future.value(Result<int, String>.error('bad')));
      expect(await ar.mapError((e) => e.length).tryGetError(), 3);
    });

    test('preserves success', () async {
      final ar = AsyncResult(Future.value(Result<int, String>.success(1)));
      expect(await ar.mapError((e) => 99).tryGetSuccess(), 1);
    });
  });

  group('AsyncResult.map', () {
    test('transforms success with successMapper', () async {
      final ar = AsyncResult(Future.value(Result<int, String>.success(3)));
      final mapped = ar.map(
        successMapper: (v) => v.toString(),
        errorMapper: (e) => 0,
      );
      expect(await mapped.tryGetSuccess(), '3');
    });

    test('transforms error with errorMapper', () async {
      final ar = AsyncResult(Future.value(Result<int, String>.error('fail')));
      final mapped = ar.map(
        successMapper: (v) => v.toString(),
        errorMapper: (e) => e.length,
      );
      expect(await mapped.tryGetError(), 4);
    });
  });

  group('AsyncResult.flatMap', () {
    test('chains on success', () async {
      final ar = AsyncResult(Future.value(Result<int, String>.success(5)));
      final chained = ar.flatMap((v) => Result.success(v.toString()));
      expect(await chained.tryGetSuccess(), '5');
    });

    test('short-circuits on error', () async {
      final ar = AsyncResult(Future.value(Result<int, String>.error('err')));
      bool called = false;
      final chained = ar.flatMap((v) {
        called = true;
        return Result.success(v.toString());
      });
      await chained.future;
      expect(called, isFalse);
    });
  });

  group('AsyncResult.flatMapAsync', () {
    test('chains with an async operation', () async {
      final ar = AsyncResult(Future.value(Result<int, String>.success(3)));
      final chained = ar.flatMapAsync(
        (v) => AsyncResult(Future.value(Result.success(v * 10))),
      );
      expect(await chained.tryGetSuccess(), 30);
    });

    test('short-circuits on error', () async {
      final ar = AsyncResult(Future.value(Result<int, String>.error('err')));
      bool called = false;
      final chained = ar.flatMapAsync((v) {
        called = true;
        return AsyncResult(Future.value(Result.success(0)));
      });
      await chained.future;
      expect(called, isFalse);
    });
  });

  group('AsyncResult.flatMapError', () {
    test('recovers from error', () async {
      final ar = AsyncResult(Future.value(Result<int, String>.error('oops')));
      final recovered = ar.flatMapError((_) => Result.success(0));
      expect(await recovered.tryGetSuccess(), 0);
    });

    test('is a no-op on success', () async {
      final ar = AsyncResult(Future.value(Result<int, String>.success(7)));
      bool called = false;
      final out = ar.flatMapError((e) {
        called = true;
        return Result.success(0);
      });
      await out.future;
      expect(called, isFalse);
    });
  });

  group('AsyncResult.swap', () {
    test('swaps success to error', () async {
      final ar = AsyncResult(Future.value(Result<String, int>.success('hi')));
      expect(await ar.swap().tryGetError(), 'hi');
    });

    test('swaps error to success', () async {
      final ar = AsyncResult(Future.value(Result<String, int>.error(99)));
      expect(await ar.swap().tryGetSuccess(), 99);
    });
  });

  group('AsyncResult.onSuccess', () {
    test('fires for success result', () async {
      String? seen;
      final ar = AsyncResult(Future.value(Result<String, int>.success('x')));
      await ar.onSuccess((v) => seen = v).future;
      expect(seen, 'x');
    });

    test('does not fire for error result', () async {
      bool called = false;
      final ar = AsyncResult(Future.value(Result<String, int>.error(1)));
      await ar.onSuccess((_) => called = true).future;
      expect(called, isFalse);
    });
  });

  group('AsyncResult.onError', () {
    test('fires for error result', () async {
      String? seen;
      final ar = AsyncResult(Future.value(Result<int, String>.error('y')));
      await ar.onError((e) => seen = e).future;
      expect(seen, 'y');
    });

    test('does not fire for success result', () async {
      bool called = false;
      final ar = AsyncResult(Future.value(Result<int, String>.success(1)));
      await ar.onError((_) => called = true).future;
      expect(called, isFalse);
    });
  });

  group('AsyncResult.getOrElse', () {
    test('returns success value on success', () async {
      final ar = AsyncResult(Future.value(Result<int, String>.success(5)));
      expect(await ar.getOrElse((_) => -1), 5);
    });

    test('returns fallback on error', () async {
      final ar = AsyncResult(Future.value(Result<int, String>.error('no')));
      expect(await ar.getOrElse((_) => -1), -1);
    });
  });

  group('AsyncResult.getOrThrow', () {
    test('returns success value', () async {
      final ar = AsyncResult(Future.value(Result<int, String>.success(7)));
      expect(await ar.getOrThrow(), 7);
    });

    test('throws SuccessResultNotFoundException on error', () {
      final ar = AsyncResult(Future.value(Result<int, String>.error('e')));
      expect(ar.getOrThrow(), throwsA(isA<SuccessResultNotFoundException>()));
    });
  });

  group('AsyncResult.tryGetSuccess / tryGetError', () {
    test('tryGetSuccess returns value on success', () async {
      final ar = AsyncResult(Future.value(Result<int, String>.success(3)));
      expect(await ar.tryGetSuccess(), 3);
    });

    test('tryGetSuccess returns null on error', () async {
      final ar = AsyncResult(Future.value(Result<int, String>.error('e')));
      expect(await ar.tryGetSuccess(), isNull);
    });

    test('tryGetError returns value on error', () async {
      final ar = AsyncResult(Future.value(Result<int, String>.error('e')));
      expect(await ar.tryGetError(), 'e');
    });

    test('tryGetError returns null on success', () async {
      final ar = AsyncResult(Future.value(Result<int, String>.success(1)));
      expect(await ar.tryGetError(), isNull);
    });
  });

  group('AsyncResult.when', () {
    test('calls whenSuccess on success', () async {
      final ar = AsyncResult(Future.value(Result<int, String>.success(1)));
      expect(await ar.when((s) => 'ok', (e) => 'err'), 'ok');
    });

    test('calls whenError on error', () async {
      final ar = AsyncResult(Future.value(Result<int, String>.error('e')));
      expect(await ar.when((s) => 'ok', (e) => 'err'), 'err');
    });
  });

  group('AsyncResult.isSuccess / isError', () {
    test('isSuccess() returns true for success', () async {
      final ar = AsyncResult(Future.value(Result<int, String>.success(1)));
      expect(await ar.isSuccess(), isTrue);
    });

    test('isSuccess() returns false for error', () async {
      final ar = AsyncResult(Future.value(Result<int, String>.error('e')));
      expect(await ar.isSuccess(), isFalse);
    });

    test('isError() returns true for error', () async {
      final ar = AsyncResult(Future.value(Result<int, String>.error('e')));
      expect(await ar.isError(), isTrue);
    });

    test('isError() returns false for success', () async {
      final ar = AsyncResult(Future.value(Result<int, String>.success(1)));
      expect(await ar.isError(), isFalse);
    });
  });

  group('AsyncResult.tryCatch', () {
    test('wraps successful async computation in Success', () async {
      final ar = AsyncResult.tryCatch(
        () async => 42,
        (e, s) => 'failed',
      );
      expect(await ar.tryGetSuccess(), 42);
    });

    test('wraps thrown async exception in Error', () async {
      final ar = AsyncResult.tryCatch(
        () async => throw Exception('boom'),
        (e, s) => 'caught',
      );
      expect(await ar.tryGetError(), 'caught');
    });

    test('onError callback receives exception and stack trace', () async {
      Object? caught;
      StackTrace? caughtStack;
      await AsyncResult.tryCatch(
        () async => throw StateError('test'),
        (e, s) {
          caught = e;
          caughtStack = s;
          return 'err';
        },
      ).future;
      expect(caught, isA<StateError>());
      expect(caughtStack, isNotNull);
    });
  });

  group('AsyncResultOf typedef', () {
    test('AsyncResultOf is assignable to AsyncResult', () async {
      AsyncResultOf<int, String> ar =
          AsyncResult(Future.value(Result<int, String>.success(1)));
      expect(await ar.tryGetSuccess(), 1);
    });
  });
}
