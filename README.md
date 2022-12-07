# multiple_result

Result package for dart inspired by the work of [dartz](https://pub.dev/packages/dartz)'s Either and Kotlin's sealed classes.

This package is perfect to those of you who just want the Multiple results
functionality from dartz. 👌

##### Old version:

If you're looking for a non null-safety version, you can find it in [here](https://github.com/higorlapa/result/tree/no-null-safety)


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

#### Handling the Result with `when`

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

#### Mapping success value with `map`

```dart
void main() {
    final result = getResult()
        .map((e) => MyObject.fromMap(e));

    result.tryGetSuccess(); //Instance of 'MyObject' 
}
```

#### Mapping error value with `mapError`

```dart
void main() {
    final result = getResult()
        .mapError((e) => MyException(e));

    result.tryGetError(); //Instance of 'MyException'

}
```

#### Chain others [Result] with `flatMap`

```dart

Result<String, MyException> checkIsEven(String input){
    if(input % 2 == 0){
        return Success(input);
    } else {
        return Error(MyException('isn`t even!'));
    }
}

void main() {
    final result = getNumberResult()
        .flatMap((s) => checkIsEven(s));
}
```

#### Add a pure 'Success' value with `pure`

```dart
void main() {
    final result = getSomethingPretty().pure(10);

    String? mySuccessResult;
    if (result.isSuccess()) {
      mySuccessResult = result.tryGetSuccess(); // 10
    }
}
```

## Unit Type

Some results do not need a specific return. Use the Unit type to signal an empty return.

```dart
    Result<Unit, Exception>
```

## Use **AsyncResult** type:

`AsyncResult<S, E>` represents an asynchronous computation.
Use this component when working with asynchronous **Result**.

**AsyncResult** has some of the operators of the **Result** object to perform data transformations (**Success** or **Error**) before executing the Future.

The operators of the **Result** object available in **AsyncResult** are:

- map
- mapError
- flatMap
- pure

`AsyncResult<S, E>` is a **typedef** of `Future<Result<S, E>>`.

```dart

AsyncResult<String, Exception> fetchProducts() async {
    try {
      final response = await dio.get('/products');
      final products = ProductModel.fromList(response.data);
      return Success(products);
    } on DioError catch (e) {
      return Error(ProductException(e.message));
    }
}

...

final state = await fetch()
    .map((products) => LoadedState(products))
    .mapLeft((error) => ErrorState(error))

```