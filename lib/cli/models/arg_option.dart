class ArgOptionModel {
  final String? abbr;
  final String? help;
  final String? valueHelp;
  final Iterable<String>? allowed;
  final Map<String, String>? allowedHelp;
  final String? defaultsTo;
  final void Function(String?)? callback;
  final bool mandatory;
  final bool hide;
  final List<String> aliases;
  final dynamic Function()? question;
  final bool? mustRequired;

  ArgOptionModel({
    this.abbr,
    this.help,
    this.valueHelp,
    this.allowed,
    this.allowedHelp,
    this.defaultsTo,
    this.callback,
    this.mandatory = false,
    this.hide = false,
    this.aliases = const [],
    this.question,
    this.mustRequired = false,
  });
}
