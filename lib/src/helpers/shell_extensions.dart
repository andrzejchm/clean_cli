import 'dart:io';

import 'package:mason_logger/mason_logger.dart';
import 'package:process_run/shell.dart';

extension ShellExtensions on Shell {
  Future<List<ProcessResult>> prettyRun(
    String script, {
    String? logTitle,
    void Function(Process process)? onProcess,
    required Logger logger,
  }) {
    logger.info(green.wrap(logTitle ?? "running: '$script'"));
    return this.run(script, onProcess: onProcess);
  }
}
