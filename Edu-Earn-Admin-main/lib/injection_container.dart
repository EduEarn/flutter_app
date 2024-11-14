import 'package:edu_earn_admin/src/auth/auth_injection.dart';
import 'package:get_it/get_it.dart';

GetIt sl = GetIt.instance;

void init() async {
  initAuth();
}
