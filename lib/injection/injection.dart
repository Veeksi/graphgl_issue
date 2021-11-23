import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

// ignore: always_use_package_imports
import 'injection.config.dart';

final GetIt getIt = GetIt.instance;

@injectableInit
Future<void> configureInjection(String env) async {
  // ignore: await_only_futures
  await $initGetIt(getIt, environment: env);
}
