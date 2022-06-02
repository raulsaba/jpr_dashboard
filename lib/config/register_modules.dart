import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

@module
abstract class RegisterModules {
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  http.Client get client => http.Client();

  InternetConnectionChecker get internetConnectionChecker =>
      InternetConnectionChecker();
}
