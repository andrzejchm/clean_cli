import 'package:mason_logger/mason_logger.dart';
import 'package:process_run/shell_run.dart';

Future<void> checkFvm(Logger logger) async {
  logger.info(lightGreen.wrap('checking fvm installation...'));
  final result = await which("fvm");
  if (result == null) {
    throw Exception("You have no fvm installed! ( https://fvm.app/ ) please make sure to install it before continuing");
  }
}
