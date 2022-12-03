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
