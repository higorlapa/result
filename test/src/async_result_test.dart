import 'package:multiple_result/src/async_result.dart';
import 'package:test/test.dart';

void main() {
  test('AsyncResult.success', () async {
    final asyncResult = AsyncResult.success(1);
    final result = await asyncResult.run();
    expect(result.tryGetSuccess(), 1);
  });

  test('AsyncResult.error', () async {
    final asyncResult = AsyncResult.error(1);
    final result = await asyncResult.run();
    expect(result.tryGetError(), 1);
  });

  test('flatMap', () async {
    final result = await AsyncResult //
            .success(1)
        .flatMap((success) => AsyncResult.success(success * 2))
        .run();
    expect(result.tryGetSuccess(), 2);
  });

  test('map', () async {
    final result = await AsyncResult //
            .success(1)
        .map((success) => success * 2)
        .run();
    expect(result.tryGetSuccess(), 2);
  });

  test('mapError', () async {
    final result = await AsyncResult //
            .error(1)
        .mapError((error) => error * 2)
        .run();
    expect(result.tryGetError(), 2);
  });

  test('pure', () async {
    final result = await AsyncResult //
            .success(1)
        .pure(10)
        .run();
    expect(result.tryGetSuccess(), 10);
  });
}
