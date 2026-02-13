part of 'theme_cubit.dart';

class ThemeState extends Equatable {
  final ThemeMode themeMode;
  final String primaryColorHex;

  const ThemeState({
    this.themeMode = ThemeMode.light,
    this.primaryColorHex = '0xFF2196F3', // Default Ocean Blue
  });

  Color get primaryColor => Color(int.parse(primaryColorHex));

  @override
  List<Object?> get props => [themeMode, primaryColorHex];

  Map<String, dynamic> toMap() {
    return {
      'themeMode': themeMode.index,
      'primaryColorHex': primaryColorHex,
    };
  }

  factory ThemeState.fromMap(Map<String, dynamic> map) {
    return ThemeState(
      themeMode: ThemeMode.values[map['themeMode'] as int],
      primaryColorHex: map['primaryColorHex'] as String,
    );
  }
}
