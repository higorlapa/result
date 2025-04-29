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
  final result = getSomethingPretty();
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

## Unit Type

Some results don't need a specific return value. Use the Unit type to signal an empty return:

```dart
    Result<Unit, Exception>
```

## ResultOf

You may have noticed the `ResultOf` typedef. It represents a more readable alternative for `Result`.