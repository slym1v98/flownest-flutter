part of 'extensions.dart';

extension StringExtension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String toCamelCase() {
    return toSnakeCase().split('_').map((word) {
      return word.capitalize();
    }).join('');
  }

  String toPascalCase() {
    return capitalize().toCamelCase();
  }

  String toSnakeCase() {
    String snakeCase = replaceAllMapped(
      RegExp(r'(?<!^)([A-Z])'),
      (Match match) => '_${match.group(0)}',
    );

    snakeCase = snakeCase.toLowerCase();
    snakeCase = snakeCase.replaceAll(RegExp(r'\s+'), '_');
    snakeCase = snakeCase.replaceAll(RegExp(r'[^a-z0-9_]'), '_');
    snakeCase = snakeCase.replaceAll(RegExp(r'_+'), '_').replaceAll(RegExp(r'^_|_$'), '');

    return snakeCase;
  }

  String toKebabCase() {
    return toSnakeCase().replaceAll('_', '-');
  }

  String toConstantCase() {
    return toSnakeCase().toUpperCase();
  }

  String toDotCase() {
    return toSnakeCase().replaceAll('_', '.');
  }

  bool isMatch(String pattern) {
    return RegExp(pattern).hasMatch(this);
  }

  bool isEmail() {
    return isMatch(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  }

  bool isPhoneNumber() {
    return isMatch(r'^\+?0[0-9]{10}$');
  }

  bool isUrl() {
    return isMatch(r'^http(s)?://([\w-]+\.)+[\w-]{2,4}(/[\w- ./?%&=]*)?$');
  }

  bool isIpv4() {
    return isMatch(r'^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$');
  }

  bool isIpv6() {
    return isMatch(r'^([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}$');
  }

  bool isHexColor() {
    return isMatch(r'^#?([0-9a-fA-F]{3}|[0-9a-fA-F]{6})$');
  }

  bool isRgbColor() {
    return isMatch(r'^rgb\((\d{1,3}), (\d{1,3}), (\d{1,3})\)$');
  }

  bool isRgbaColor() {
    return isMatch(r'^rgba\((\d{1,3}), (\d{1,3}), (\d{1,3}), (0(\.\d+)?|1(\.0+)?)\)$');
  }

  bool isHslColor() {
    return isMatch(r'^hsl\((\d{1,3}), (\d{1,3})%, (\d{1,3})%\)$');
  }

  bool isHslaColor() {
    return isMatch(r'^hsla\((\d{1,3}), (\d{1,3})%, (\d{1,3})%, (0(\.\d+)?|1(\.0+)?)\)$');
  }

  bool get isValidUrl {
    final regex = RegExp(r"(https?|http)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:,.;]*)?");
    return (Uri.tryParse(this)?.hasAbsolutePath ?? false) || regex.hasMatch(this);
  }

  bool get isStorage => RegExp(r'^\/(storage|data|private/var/mobile)[^\.]').hasMatch(this);

  bool get isStaticAssets => startsWith('assets');

  bool get isSvg => endsWith('.svg');

  bool get isNetwork => isValidUrl && !isStorage && !isStaticAssets;
}
