# multiple_result

A Result package for Dart inspired by [dartz](https://pub.dev/packages/dartz)'s Either type and Kotlin's sealed classes.

This package is perfect for those who just want the multiple results 
functionality from dartz. 👌

## Using the **Result** type:

In your function signature, declare it to return a Result type:
```dart
Result getSomething();
```
Then specify the Success and Error types:

```dart
Result<String, Exception> getSomething() {

}
```

When returning from the function, simply use:
```dart
return Success('Success!');
```

or

```dart
return Error(Exception('Some error happened...'));
```

A complete function looks like this:

```dart
Future<Result<String, Exception>> getSomething() async {
    
    try {
      final response = await _api.get('/foo');
      final data = response.data['bar'];
      return Success(data);
    } catch(e) {
      return Error(e);
    }
}
```

### Handling Results

#### Using `switch`:

```dart
void main() {
  final result = getSomething();
  switch(result) {
    case Success():
      print("${result.success}");
      break;
    case Error():
      print("${result.error}");
      break;
  }
}
```

Or with Switch Expression:

```Dart
  final result = await getSomething();
  final output = switch (result) {
    Success(success: var s) => processSuccess(s),
    Error(error: var e) => handleError(e)
  };
```

#### Using `when`:

```dart
void main() {
    final result = await getSomething();
    final String message = result.when(
        (data) {
          // handle the success here
          return "Successfully fetched data: $data";
        },
        (error) {
          // handle the error here
          return "error: $error";
        },
    );
}
```

#### Using `if case`:

```dart
void main() {
  final result = getSomething();
  if(result case Success()) {
    // access to .success value
    print("${result.success}");
  }
}
```

#### Using `whenSuccess` or `whenError`

```dart 
    final result = getSomethingPretty();
    // Note that [whenSuccess] or [whenError] will only be executed if
    // the result is a Success or an Error respectively. 
    final output = result.whenSuccess((name) {
        // handle here the success
        return "";
    });
    
    final result = getSomethingPretty();
    
    // If [result] is NOT an Error, this [output] will be null.
    final output = result.whenError((exception) {
        // handle here the error
        return "";
    });
```

#### Using `getOrThrow`

You can use `getOrThrow` to get the value when you're sure that the result is a `Success`.
Be aware that calling this method when the result is actually an `Error` will throw a `SuccessResultNotFoundException`.

```dart
    final result = await getSomething();

    if (result.isSuccess()) {
      // Here, you can "safely" get the success result as it was verified in the previous line.
      final mySuccessResult = result.getOrThrow();
    }
```

#### Using `tryGetSuccess`

```dart
void main() {
    final result = getSomethingPretty();

    String? mySuccessResult;
    if (result.isSuccess()) {
      mySuccessResult = result.tryGetSuccess();
    }
}
```

#### Using `tryGetError`

```dart
void main() {
    final result = getSomethingPretty();

    Exception? myException;
    if (result.isError()) {
      myException = result.tryGetError();
    }
}
```

## Using `getBoth`

The `getBoth` method returns a record (Dart's named tuple) containing both the success and error values of a `Result`. 
Only one of these will be non-null, depending on whether the result is a `Success` or an `Error`.

- If the result is a `Success`, the `success` field will contain the value, and `error` will be `null`.
- If the result is an `Error`, the `error` field will contain the error, and `success` will be `null`.

This is useful for destructuring or pattern matching without having to check the type explicitly.

**Example:**

```dart
void main() {
  final result = getSomething();
  final (:success, :error) = result.getBoth();
  
  if (success != null) {
    print("Success: $success");
  } else {
    print("Error: $error");
  }
}
```

## Transforming Results

The Result class provides several methods for transforming values while preserving the success/error structure:

### Using `map`

The `map` method transforms both the success and error values of a Result:

```dart
Result<int, Exception> result = fetchNumber();
Result<String, String> transformed = result.map(
  successMapper: (number) => number.toString(),
  errorMapper: (exception) => exception.toString()
);
```

### Using `mapSuccess`

The `mapSuccess` method transforms only the success value, preserving any error:

```dart
Result<int, Exception> result = fetchNumber();
Result<String, Exception> transformed = result.mapSuccess(
  (number) => number.toString()
);
```

### Using `mapError`

The `mapError` method transforms only the error value, preserving any success:

```dart
Result<int, Exception> result = fetchNumber();
Result<int, String> transformed = result.mapError(
  (exception) => exception.toString()
);
```

### Using `flatMap`

The `flatMap` method is powerful for chaining operations that can fail. Unlike `mapSuccess` which wraps the returned value in a Result, `flatMap` expects your function to return a Result directly:

```dart
Result<int, String> fetchNumber() => Success(5);

Result<String, String> parseNumber(int n) {
  if (n > 0) {
    return Success(n.toString());
  } else {
    return Error("Cannot parse negative numbers");
  }
}

// Chain operations that might fail
Result<String, String> result = fetchNumber().flatMap(
  (number) => parseNumber(number)
);
```

The key difference between `mapSuccess` and `flatMap`:
- `mapSuccess` takes a function that returns a value `T` and wraps it in a Result
- `flatMap` takes a function that returns a Result directly, avoiding nested Results

## Unit Type

Some results don't need a specific return value. Use the Unit type to signal an empty return:

```dart
    Result<Unit, Exception>
```

## ResultOf

You may have noticed the `ResultOf` typedef. It represents a more readable alternative for `Result`.