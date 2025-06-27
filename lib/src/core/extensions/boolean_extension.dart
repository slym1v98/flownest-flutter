part of 'extensions.dart';

extension BooleanExtension on bool {
  bool and(bool other) {
    return this && other;
  }

  bool or(bool other) {
    return this || other;
  }

  bool not() {
    return !this;
  }

  bool nand(bool other) {
    return !(this && other);
  }

  bool nor(bool other) {
    return !(this || other);
  }

  bool xor(bool other) {
    return this != other;
  }

  bool xnor(bool other) {
    return this == other;
  }

  bool implies(bool other) {
    return !this || other;
  }

  bool reverseImplies(bool other) {
    return this && !other;
  }
}
