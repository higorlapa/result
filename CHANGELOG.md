## 4.0.0 - 12/21/2022

* Major release. [BREAKING] 
  * Drop the support for every parse/helper method and keep the [Result] simple as it was its initial purpose. 
  * Rename `onSuccess` and `onError` to `whenSuccess` and `whenError` to match the `when` method.

## [3.2.0] - 12/08/2022

* **Change to `flatMap` in `AsyncResult` allowing synchronous `Result` chaining**:<br>
We noticed that we can receive a `FutureOr` instead of a `Future` in the `flatMap` anonymous function, more specifically in the `AsyncResult`.
Now we hope to be able to chain asynchronous and synchronous functions in `AsyncResult`. <br>
Note that this update only reflects on the `AsyncResult`, this means that the `Result.flatMap` will not change and will still only accept synchronous results(No-Future here).

* **New operators for `Error` result**: <br>
We have always been supporting `Success` value transformation
and now we want to show that we care about the flow of errors.<br>
That's why we added 2 specific operators for `Result` of `Error`:
   1. `flatMapError`.
   2. `pureError`

* **Welcome `fold`**:<br>
`multiple_result` is a proposal based on `Either` from `dartz`, `sealed class` from `Koltin`, in addition to the `Result` objects seen in `Swift` and `Kotlin`. Some developers might be uncomfortable without `fold`. That's why we are bringing `fold` as an alias of `when`, that is, both `when` and `fold` do exactly the same thing!<br>
Help us figure out which one to remove in the near future.

* **SWAP**:<br>
This new operand will be useful when you need to swap `Success` and `Error`.
```dart
Result<String, int> result =...;
Result<int, String> newResult = result.swap();
```

* fix doc

## [3.1.0] - 12/05/2022
* 100% Test Coverage!!.
* Refactor `AsyncResult`.
* Remove deprecated operator `get()`.

## [3.0.0] - 12/05/2022
Thanks to [Jacob](https://github.com/jacobaraujo7)
* Add new operators in Result:
  New operators will allow transforming success and error values before the values are extracted.
   * map
   * mapError
   * flatMap
   * pure
* Create Unit type (and deprecate `SuccessResult`)
* Add `AsyncResult` to perform asynchronous computation.

## [2.0.0] - 12/03/2022

* BREAKING: Rename `getSuccess` to `tryGetSuccess` and `getError` to `tryGetError` methods.
* BREAKING: Flip the order of the Success and Error types. Thanks to [JoDeveloper](https://github.com/JoDeveloper) for executing and [RalphBergmannKMB](https://github.com/RalphBergmannKMB) for proposing.
  * If you `Result<Exception, String>` now you must use `Result<String, Exception>` to improve readability.
* Add `onSuccess` and `onError` methods to handle the result only in these cases.

## [1.0.4] - 07/19/2021

* Adds getSuccess and getError methods
* Adds SuccessResult and success const

## [1.0.3] - 05/02/2021

* Adds @immutable annotation to Success and Error classes to help in the tests | Thanks to [Eronildo](https://github.com/Eronildo)!

## [1.0.2] - 03/28/2021

* Adds @sealed annotation to Result class | Thanks to [Jacob](https://github.com/jacobaraujo7)!

## [1.0.1] - 03/26/2021

* Adds documentation
* Changes library to multiple_result

## [1.0.0] - 03/23/2021

* Initial release
