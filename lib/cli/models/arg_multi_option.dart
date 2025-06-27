class ArgMultiOptionModel {
  final String? abbr;
  final String? help;
  final String? valueHelp;
  final Iterable<String>? allowed;
  final Map<String, String>? allowedHelp;
  final Iterable<String>? defaultsTo;
  final void Function(List<String>)? callback;
  final bool splitCommas;
  final bool hide;
  final List<String> aliases;
  final dynamic Function()? question;
  final bool? mustRequired;

  ArgMultiOptionModel({
    this.abbr,
    this.help,
    this.valueHelp,
    this.allowed,
    this.allowedHelp,
    this.defaultsTo,
    this.callback,
    this.splitCommas = true,
    this.hide = false,
    this.aliases = const [],
    this.question,
    this.mustRequired = false,
  });
}
