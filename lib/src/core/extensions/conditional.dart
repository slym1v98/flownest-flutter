class Conditional<T> {
  bool condition;
  T? passed;
  T? failed;

  Conditional({
    required this.condition,
    this.passed,
    this.failed,
  });

  T? get value => condition ? passed : failed;

  T? get passedValue => passed;

  T? get failedValue => failed;
}
