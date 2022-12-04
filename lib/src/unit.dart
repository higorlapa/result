import 'package:meta/meta.dart';

/// Used instead of `void` as a return statement for a function
/// when no value is to be returned.
///
/// There is only one value of type [Unit].
@sealed
class Unit {
  static const Unit _unit = Unit._instance();
  const Unit._instance();

  @override
  String toString() => '()';
}

/// Used instead of `void` as a return statement for a function when
///  no value is to be returned.
const unit = Unit._unit;
