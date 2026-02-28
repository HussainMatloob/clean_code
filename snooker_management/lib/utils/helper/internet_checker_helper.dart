import 'package:snooker_management/utils/helper/internet_checker_helper_web.dart';

import 'internet_checker_helper_stub.dart'
    if (dart.library.html) 'internet_checker_helper_web.dart'
    if (dart.library.io) 'internet_checker_helper_io.dart';

abstract class InternetCheckerHelper {
  static Future<bool> isConnectedToInternet() =>
      InternetCheckerImpl.isConnectedToInternet();
}

// import 'package:http/http.dart' as http;

// class InternetCheckerHelper {
//   static Future<bool> isConnectedToInternet() async {
//     try {
//       final response = await http.get(Uri.parse('https://www.google.com'));
//       return response.statusCode == 200; // If status code is 200, connected
//     } catch (e) {
//       return false; // If error occurs, no internet connection
//     }
//   }
// }
