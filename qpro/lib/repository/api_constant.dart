class APIConstant {

  static const String ipaddress = "http://192.168.1.106:8000";

  static const String URL = "${ipaddress}/api/";

  // auth module
  static String get LoginURL => "${APIConstant.URL}login";
  static String get RefreshURL => "${APIConstant.URL}auth/refresh";
  static String get RegisterURL => "${APIConstant.URL}signup";
  static String get ForgotPasswordURL =>
      "${APIConstant.URL}auth/forgot-password";
  static String get LogoutURL => "${APIConstant.URL}auth/logout";

}