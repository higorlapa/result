import 'package:multiple_result/multiple_result.dart';

void main() {
  final resultNameOrError = _getName();
  _handleResultInSwitch(resultNameOrError);
  final resultForcedNameOrError = _getName(forceError: true);
  _handleResultInWhen(resultForcedNameOrError);

  _handleWithDirectionalFunction(
    result: resultNameOrError,
    forcedErrorResult: resultForcedNameOrError,
  );

  // Example with if case
  if (resultNameOrError case Success()) {
    print(resultNameOrError.success);
  }
}

void _handleResultInSwitch(Result<String, Exception> result) {
  switch (result) {
    case Success():
      print("result - success: ${result.success} handled by switch");
      break;
    case Error():
      print("result - error: ${result.error} handled by switch");
      break;
  }
}

void _handleResultInWhen(Result<String, Exception> result) {
  result.when(
    (success) {
      print("result - success: ${success} handled by switch");
    },
    (error) {
      print("result - error: ${error} handled by switch");
    },
  );
}

void _handleWithDirectionalFunction({
  required Result<String, Exception> result,
  required Result<String, Exception> forcedErrorResult,
}) {
  result.whenSuccess((success) {
    print("handled success by directional function. Result: $success");
  });

  result.whenError((success) {
    print("handled success by directional function. Result: $success");
  });
}

ResultOf<String, Exception> _getName({bool forceError = false}) {
  if (forceError) {
    return Result.error(Exception("Error forced"));
  }
  return const Result.success("Higor");
}
