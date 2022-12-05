import 'package:meta/meta.dart';

/// Used instead of `void` as a return statement for a function
/// when no value is to be returned.
///
/// There is only one value of type [Unit].
@sealed
class Unit {
  const Unit._();

  @override
  String toString() => 'Unit';
}

/// Used instead of `void` as a return statement for a function when
///  no value is to be returned.
const unit = Unit._();
