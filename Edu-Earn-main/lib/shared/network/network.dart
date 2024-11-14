import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

abstract class NetworkInfo {
  Future<bool> hasInternet();
}

class NetworkInfoImpl implements NetworkInfo {
  @override
  Future<bool> hasInternet() async {
    return InternetConnection().hasInternetAccess;
  }
}
