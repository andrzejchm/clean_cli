import 'package:mason_logger/mason_logger.dart';

extension LoggerExtensions on Logger {
  void title(String text) {
    info(backgroundGreen.wrap("#" * 20));
    info(backgroundGreen.wrap(text.toUpperCase()));
    info(backgroundGreen.wrap("#" * 20));
  }
}
