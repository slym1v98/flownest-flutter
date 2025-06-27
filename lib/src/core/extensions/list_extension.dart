part of 'extensions.dart';

extension ListExtension on List {
  List<T> addAll<T>(List<T> list) {
    return [...(this as List<T>), ...list];
  }

  List addIf<T>(bool condition, T item) {
    return condition ? [...(this as List<T>), item] : this;
  }

  List<T> remove<T>(T item) {
    return List<T>.from(this)..remove(item);
  }

  List<T> removeAt<T>(int index) {
    return List<T>.from(this)..removeAt(index);
  }

  List<T> removeWhere<T>(bool Function(T) test) {
    return List<T>.from(this)..removeWhere(test);
  }

  List<T> retainWhere<T>(bool Function(T) test) {
    return List<T>.from(this)..retainWhere(test);
  }

  List<T> where<T>(bool Function(T) test) {
    return List<T>.from(this)..where(test);
  }

  List<T> map<T>(T Function(T) f) {
    return List<T>.from(this)..map(f);
  }

  List<T> expand<T>(Iterable<T> Function(T) f) {
    return List<T>.from(this)..expand(f);
  }

  List<T> cast<T>() {
    return List<T>.from(this);
  }

  List get reversed {
    return List.from(this)..reversed;
  }

  List get shuffled {
    return List.from(this)..shuffle();
  }

  List get sorted {
    return List.from(this)..sort();
  }

  List get unique {
    return List.from(this)..toSet().toList();
  }

  List get duplicates {
    return List.from(this)..where((item) => count(item) > 1).toSet().toList();
  }

  int count<T>(T item) {
    return List<T>.from(this).where((i) => i == item).length;
  }

  String joinWith<T>(String separator) {
    return List<T>.from(this).join(separator);
  }
}
