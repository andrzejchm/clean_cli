import 'package:dotenv/dotenv.dart';

extension DotenvHelpers on DotEnv {
  void throwIfNotDefined({
    required String filePath,
    required Iterable<String> vars,
  }) {
    final undefined = vars.map((e) => this.isDefined(e) ? null : e).where((element) => element != null).toList();
    if (undefined.isNotEmpty) {
      throw Exception(
        'some of the env variables were not specified: [$undefined]. make sure to add them to "$filePath" file and retry',
      );
    }
  }
}
