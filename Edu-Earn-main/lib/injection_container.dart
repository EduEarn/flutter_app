import 'package:edu_earn/shared/network/network.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'src/applications/application_injection.dart';
import 'src/authentication/auth_injection.dart';
import 'src/bookmark/bookmark_injection.dart';

GetIt sl = GetIt.instance;

void init() async {
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
  initAuth();
  initBookmark();
  initJobApplication();
}
