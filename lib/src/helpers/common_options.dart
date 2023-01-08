import 'package:clean_cli/src/model/cli_option.dart';

const cliOptionWorkingDirectory = CliOption(
  name: 'directory',
  abbr: 'd',
  mandatory: false,
  defaultsTo: '.',
  help: "determines the working directory to run deployment commands",
);
