import 'package:args/args.dart';
import 'package:mason_logger/src/mason_logger.dart';

class CliOption {
  final String name;
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

  const CliOption({
    required this.name,
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
  });

  void addTo(ArgParser argParser) => argParser.addOption(
        name,
        abbr: abbr,
        help: help,
        valueHelp: valueHelp,
        allowed: allowed,
        allowedHelp: allowedHelp,
        defaultsTo: defaultsTo,
        callback: callback,
        mandatory: mandatory,
        hide: hide,
        aliases: aliases,
      );

  String? getFrom(ArgResults? argResults, {Logger? logger}) {
    if (logger != null) {
      printLog(logger, argResults);
    }
    return argResults?[name];
  }

  void printLog(Logger logger, ArgResults? argResults) {
    logger.info("setting '$name' to ${getFrom(argResults)}");
  }
}
