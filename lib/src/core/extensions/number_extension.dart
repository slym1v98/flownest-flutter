part of 'extensions.dart';

extension NumExtension on num {
  String toCurrency({
    String symbol = '\$',
    int decimal = 2,
    String decimalSeparator = '.',
    String thousandSeparator = ',',
  }) {
    final String formatted = toStringAsFixed(decimal);
    final List<String> split = formatted.split('.');
    final String beforeDecimal = split[0];
    final String afterDecimal = split.length > 1 ? '$decimalSeparator${split[1]}' : '';
    final RegExp regExp = RegExp(r'\B(?=(\d{3})+(?!\d))');
    final String withThousandSeparator = beforeDecimal.replaceAllMapped(regExp, (match) {
      return '${match[0]}$thousandSeparator';
    });
    return '$symbol$withThousandSeparator$afterDecimal';
  }

  String toPercentage({
    int decimal = 2,
    String decimalSeparator = '.',
  }) {
    final String formatted = toStringAsFixed(decimal);
    final List<String> split = formatted.split('.');
    final String beforeDecimal = split[0];
    final String afterDecimal = split.length > 1 ? '$decimalSeparator${split[1]}' : '';
    return '$beforeDecimal$afterDecimal%';
  }

  String toOrdinal() {
    final int value = abs().toInt();
    final int lastDigit = value % 10;
    final int lastTwoDigits = value % 100;
    if (lastTwoDigits >= 11 && lastTwoDigits <= 13) {
      return '$value' 'th';
    }
    switch (lastDigit) {
      case 1:
        return '$value' 'st';
      case 2:
        return '$value' 'nd';
      case 3:
        return '$value' 'rd';
      default:
        return '$value' 'th';
    }
  }

  num get validator => this;

  double get toDouble => validator.toDouble();

  int get toInt => validator.toInt();

  DateTime? toDate({bool seconds = false}) {
    return DateTime.fromMillisecondsSinceEpoch(validator.round() * (seconds ? 1 : 1000));
  }
}
