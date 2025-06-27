import 'package:args/args.dart';

import 'models/arg_flag.dart';
import 'models/arg_multi_option.dart';
import 'models/arg_option.dart';

class ArgumentsParser {
  final ArgParser _parser = ArgParser();
  final Map<String, ArgOptionModel> _options = {};
  final Map<String, ArgMultiOptionModel> _multiOptions = {};
  final Map<String, ArgFlagModel> _flags = {};

  bool _force = false;

  factory ArgumentsParser() {
    return _instance;
  }

  ArgumentsParser._();

  static final ArgumentsParser _instance = ArgumentsParser._();

  ArgParser get parser => _parser;

  Map<String, dynamic> get options => _options;

  Map<String, dynamic> get multiOptions => _multiOptions;

  Map<String, dynamic> get flags => _flags;

  void addForceFlag({
    String? help,
    bool? defaultsTo = false,
    bool negatable = true,
    void Function(bool)? callback,
    bool hide = false,
    List<String> aliases = const [],
  }) {
    _force = true;
    _parser.addFlag(
      'force',
      abbr: 'f',
      help: help,
      defaultsTo: defaultsTo,
      negatable: negatable,
      callback: callback,
      hide: hide,
      aliases: aliases,
    );
  }

  void addFlags(Map<String, ArgFlagModel> flags) {
    _flags.addAll(flags);
    flags.forEach((key, value) {
      _parser.addFlag(
        key,
        abbr: value.abbr,
        help: value.help,
        defaultsTo: value.defaultsTo,
        negatable: value.negatable,
        callback: value.callback,
        hide: value.hide,
        aliases: value.aliases,
      );
    });
  }

  void addMultiOptions(Map<String, ArgMultiOptionModel> multiOptions) {
    _multiOptions.addAll(multiOptions);

    multiOptions.forEach((key, value) {
      _parser.addMultiOption(
        key,
        abbr: value.abbr,
        help: value.help,
        valueHelp: value.valueHelp,
        allowed: value.allowed,
        allowedHelp: value.allowedHelp,
        defaultsTo: value.defaultsTo,
        callback: value.callback,
        hide: value.hide,
        aliases: value.aliases,
      );
    });
  }

  void addOptions(Map<String, ArgOptionModel> options) {
    _options.addAll(options);

    options.forEach((key, value) {
      _parser.addOption(
        key,
        abbr: value.abbr,
        help: value.help,
        valueHelp: value.valueHelp,
        allowed: value.allowed,
        allowedHelp: value.allowedHelp,
        defaultsTo: value.defaultsTo,
        callback: value.callback,
        mandatory: value.mandatory,
        hide: value.hide,
        aliases: value.aliases,
      );
    });
  }

  Future<Map<String, dynamic>> parse(List<String> args) async {
    ArgResults result = _parser.parse(args);
    Map<String, dynamic> params = {};

    params.addEntries(
      options.keys.map((arg) => MapEntry(arg, result.option(arg))).toList(),
    );
    params.addEntries(
      multiOptions.keys.map((arg) => MapEntry(arg, result.multiOption(arg))).toList(),
    );
    params.addEntries(
      flags.keys.map((arg) => MapEntry(arg, result.flag(arg))).toList(),
    );

    for (var key in options.keys) {
      while ((options[key].mustRequired! as bool) && params[key] == null) {
        dynamic value = options[key].question is Future Function()
            ? await options[key].question!()
            : options[key].question!();
        if (value != null) {
          params[key] = value;
        }
      }
    }

    for (var key in multiOptions.keys) {
      while ((multiOptions[key].mustRequired! as bool) && params[key].length == 0) {
        dynamic value = multiOptions[key].question is Future Function()
            ? await multiOptions[key].question!()
            : multiOptions[key].question!();
        if (value != null) {
          params[key] = value;
        }
      }
    }

    for (var key in flags.keys) {
      while ((flags[key].mustRequired! as bool) && params[key] == null) {
        dynamic value = flags[key].question is Future Function()
            ? await flags[key].question!()
            : flags[key].question!();
        if (value != null) {
          params[key] = value;
        }
      }
    }

    if (_force) {
      params['force'] = result['force'];
    }

    return params;
  }
}
