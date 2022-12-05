import 'package:multiple_result/multiple_result.dart';
import 'package:test/test.dart';

void main() {
  test('flatMap', () async {
    final result = await Success(1) //
        .toAsyncResult()
        .flatMap((success) async => Success(success * 2));
    expect(result.tryGetSuccess(), 2);
  });

  test('map', () async {
    final result = await Success(1) //
        .toAsyncResult()
        .map((success) => success * 2);

    expect(result.tryGetSuccess(), 2);
  });

  test('mapError', () async {
    final result = await Error(1) //
        .toAsyncResult()
        .mapError((error) => error * 2);
    expect(result.tryGetError(), 2);
  });

  test('pure', () async {
    final result = await Success(1).toAsyncResult().pure(10);

    expect(result.tryGetSuccess(), 10);
  });
}
