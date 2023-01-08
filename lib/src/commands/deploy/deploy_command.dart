import 'package:args/command_runner.dart';
import 'package:clean_cli/src/commands/deploy/deploy_public_test_command.dart';
import 'package:mason_logger/mason_logger.dart';

class DeployCommand extends Command<int> {
  /// {@macro sample_command}
  DeployCommand({
    required Logger logger,
  }) {
    addSubcommand(DeployPublicTestCommand(logger: logger));
  }

  @override
  String get description => 'Command used to start deployments (firebase | testflight | google play)';

  @override
  String get name => 'deploy';
}
