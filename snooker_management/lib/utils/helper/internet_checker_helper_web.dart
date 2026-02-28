import 'dart:html' as html;

class InternetCheckerImpl {
  static Future<bool> isConnectedToInternet() async {
    return html.window.navigator.onLine ?? false;
  }
}
