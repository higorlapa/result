# multiple_result

Result package for dart inspired by the work of [dartz](https://pub.dev/packages/dartz)'s Either and Kotlin's sealed classes.

This package is perfect to those of you who just want the Multiple results
functionality from dartz. 👌

## About version 4.0.0 and previous releases

Versions 3.0.0 to 3.2.0 represented the common effort in making this package better. That's why so many breaking changes
in just a small time. 

Once these updates stopped (because they decided to fork the project) I decided to remove these updates
and keep it simple as it was always supposed to be. It's open to suggestions and you should not expect 
more of these breaking changes any time soon. The package will keep evolving and responding to dart's updates.

## Use **Result** type:

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

#### Handling the Result with `when`:

```dart
void main() {
    final result = getSomethingPretty();
     final String message = result.when(
        (success) {
          // handle the success here
          return "success";
        },
         (error) {
          // handle the error here
          return "error";
        },
    );

}
```

#### Handling the Result with `whenSuccess` or `whenError`

```dart 
    final result = getSomethingPretty();
    // notice that [whenSuccess] or [whenError] will only be executed if
    // the result is a Success or an Error respectivaly. 
    final output = result.whenSuccess((name) {
        // handle here the success
        return "";
    });
    
    final result = getSomethingPretty();
    
    // [result] is NOT an Error, this [output] will be null.
    final output = result.whenError((exception) {
        // handle here the error
        return "";
    });
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

## Unit Type

Some results do not need a specific return. Use the Unit type to signal an empty return.

```dart
    Result<Unit, Exception>
```
## ResultOf

You may have noticed the `ResultOf` typedef. It represents a better readability for `Result`, but as 
it would be another breaking change, leaving it as an alias would be good enough. 