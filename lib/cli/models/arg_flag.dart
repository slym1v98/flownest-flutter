class ArgFlagModel {
  final String? abbr;
  final String? help;
  final bool? defaultsTo;
  final bool negatable;
  final void Function(bool)? callback;
  final bool hide;
  final List<String> aliases;
  final dynamic Function()? question;
  final bool? mustRequired;

  ArgFlagModel({
    this.abbr,
    this.help,
    this.defaultsTo = false,
    this.negatable = true,
    this.callback,
    this.hide = false,
    this.aliases = const [],
    this.question,
    this.mustRequired = false,
  });
}
