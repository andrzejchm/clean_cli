import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';

extension RunCommand<T> on Command<T> {
  Future<int> safeRun(Logger logger, Future<int?> Function() command) async {
    try {
      final result = await command();
      return result ?? ExitCode.success.code;
    } catch (ex, stack) {
      logger.err(ex.toString());
      if (globalResults?['verbose'] == true) {
        logger.err(stack.toString());
      }
      return ExitCode.usage.code;
    }
  }
}
