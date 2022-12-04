# multiple_result

Result package for dart inspired by the work of [dartz](https://pub.dev/packages/dartz)'s Either and Kotlin's sealed classes.

This package is perfect to those of you who just want the Multiple results
functionality from dartz. 👌

##### Old version:

If you're looking for a non null-safety version, you can find it in [here](https://github.com/higorlapa/result/tree/no-null-safety)


## How to use it

In the return of a function, set it to return a Result type;
```dart
Result getSomethingPretty();
```
then add the Success and the Error types.

```dart

Result<String, Exception> getSomethingPretty() {

}

```

in return of the function, you just need to return
```dart
return Success('Something Pretty');
```

or

```dart
return Error(Exception('something ugly happened...'));
```

The function should look something like this:

```dart

Result<String, Exception> getSomethingPretty() {
    if(isOk) {
        return Success('OK!');
    } else {
        return Error(Exception('Not Ok!'));
    }
}

```

#### Handling the Result with `when`

```dart
void main() {
    final result = getSomethingPretty();
     final String message = result.when(
         (error) {
          // handle the error here
          return "error";
        }, (success) {
          // handle the success here
          return "success";
        },
    );

}
```

#### Handling the Result with `onSuccess` or `onError`

```dart 
    final result = getSomethingPretty();
    // notice the [onSuccess] or [onError] will only be executed if
    // the result is a Success or an Error respectivaly. 
    final output = result.onSuccess((name) {
        // handle here the success
        return "";
    });
    
    final result = getSomethingPretty();
    
    // [result] is NOT an Error, this [output] will be null.
    final output = result.onError((exception) {
        // handle here the error
        return "";
    });
```

#### Handling the Result with `get`

```
note: [get] is now deprecated and will be removed in the next version.
```

```dart
void main() {
    final result = getSomethingPretty();

    String? mySuccessResult;
    if (result.isSuccess()) {
      mySuccessResult = result.get();
    }
}
```


#### Handling the Result with `tryGetSuccess`

```dart
void main() {
    final result = getSomethingPretty();

    String? mySuccessResult;
    if (result.isSuccess()) {
      mySuccessResult = result.tryGetSuccess();
    }
}

```


#### Handling the Result with `tryGetError`

```dart
void main() {
    final result = getSomethingPretty();

    Exception? myException;
    if (result.isError()) {
      myException = result.tryGetError();
    }
}
```


