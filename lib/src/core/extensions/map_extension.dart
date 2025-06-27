part of 'extensions.dart';

extension MapExtension on Map {
  Map where(bool Function(String key, dynamic value) test) {
    return Map.fromEntries(entries.where((entry) => test(entry.key as String, entry.value)));
  }

  Map map(MapEntry Function(String key, dynamic value) f) {
    return Map.fromEntries(entries.map((entry) => f(entry.key as String, entry.value)));
  }
}
