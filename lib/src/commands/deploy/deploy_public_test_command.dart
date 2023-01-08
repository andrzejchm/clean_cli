import 'package:args/command_runner.dart';
import 'package:clean_cli/src/helpers/check_fvm.dart';
import 'package:clean_cli/src/helpers/common_options.dart';
import 'package:clean_cli/src/helpers/dotenv_helpers.dart';
import 'package:clean_cli/src/helpers/logger_extensions.dart';
import 'package:clean_cli/src/helpers/run_command.dart';
import 'package:clean_cli/src/helpers/shell_extensions.dart';
import 'package:dotenv/dotenv.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:process_run/shell.dart';

class DeployPublicTestCommand extends Command<int> {
  static const keyIpaBuildArgs = "ipa_build_args";
  static const keyAppbundleBuildArgs = "apk_build_args";
  static const keyDeployAndroidLane = "deploy_android_lane";
  static const keyDeployIosLane = "deploy_ios_lane";
  static const keyDotenvFile = "dotenv_file";

  /// {@macro sample_command}
  DeployPublicTestCommand({
    required Logger logger,
  }) : _logger = logger {
    cliOptionWorkingDirectory.addTo(argParser);
    argParser.addOption(
      keyIpaBuildArgs,
      help: "arguments passed to the 'flutter build ipa' command",
      defaultsTo: '--release',
    );
    argParser.addOption(
      keyAppbundleBuildArgs,
      help: "arguments passed to the 'flutter build appbundle' command",
      defaultsTo: '--release',
    );
    argParser.addOption(
      keyDeployAndroidLane,
      help: "lane to use for android deployment",
      defaultsTo: 'deploy_google_alpha',
    );
    argParser.addOption(
      keyDeployIosLane,
      help: "lane to use for iOS deployment",
      defaultsTo: 'deploy_testflight',
    );
    argParser.addOption(
      keyDotenvFile,
      help: ".env file containing all credentials needed to sign the app and deploy",
      defaultsTo: '.env.deploy',
    );
  }

  @override
  String get description => 'Deploys the app to testflight and google play alpha track';

  @override
  String get name => 'public_test';

  final Logger _logger;

  @override
  Future<int> run() => safeRun(_logger, () async {
        argResults?[keyDotenvFile];
        final workingDir = cliOptionWorkingDirectory.getFrom(argResults, logger: _logger);
        final dotEnvFileName = argResults?[keyDotenvFile] as String;
        var dotEnvFilePath = '$workingDir/$dotEnvFileName';
        final env = DotEnv(includePlatformEnvironment: true)..load([dotEnvFilePath]);
        env.throwIfNotDefined(filePath: dotEnvFilePath, vars: [
          'ANDROID_STORE_PASSWORD',
          'ANDROID_KEY_PASSWORD',
          'ANDROID_GOOGLE_PLAY_KEY_DATA',
        ]);
        await checkFvm(_logger);
        final shell = Shell(workingDirectory: workingDir, environment: env.map);
        // _logger.title("start deployment");
        // await shell.prettyRun('fvm flutter clean', logger: _logger);
        //
        // _logger.title("build ipa");
        // await shell.prettyRun('fvm flutter build ipa ${argResults?[keyIpaBuildArgs]}', logger: _logger);
        //
        // _logger.title("build appbundle");
        // await shell.prettyRun('fvm flutter build appbundle ${argResults?[keyAppbundleBuildArgs]}', logger: _logger);

        _logger.title("deploy android");
        ;
        await shell.pushd('android').prettyRun(
              'bundle exec fastlane ${argResults?[keyDeployAndroidLane]}',
              logger: _logger,
            );

        _logger.info(backgroundGreen.wrap("\n\n\nDeploying iOS\n\n\n"));
        await shell.pushd('ios').prettyRun(
              'pushd ios; bundle exec fastlane ${argResults?[keyDeployIosLane]}',
              logger: _logger,
            );
        shell.popd();
      });
}
