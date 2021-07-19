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
then add the Error and the Success types.

```dart

Result<Exception, String> getSomethingPretty() {

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

Result<Exception, String> getSomethingPretty() {
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


#### Handling the Result with `get`

```dart
void main() {
    final result = getSomethingPretty();

    String? mySuccessResult;
    if (result.isSuccess()) {
      mySuccessResult = result.get();
    }
}
```


#### Handling the Result with `getSuccess`

```dart
void main() {
    final result = getSomethingPretty();

    String? mySuccessResult;
    if (result.isSuccess()) {
      mySuccessResult = result.getSuccess();
    }
}

```


#### Handling the Result with `getError`

```dart
void main() {
    final result = getSomethingPretty();

    Exception? myException;
    if (result.isError()) {
      myException = result.getError();
    }
}
```


