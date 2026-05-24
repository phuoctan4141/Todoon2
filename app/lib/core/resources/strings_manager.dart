class AppStrings {
  AppStrings._();

  static const String appName = "ToDoon";
  static const String homeUid = "home";
  static const String dailyFocusUid = "daily_focus";
  static const String dailyFocusTitle = "Daily Focus";

  static String debug({required String tag, required String message}) =>
      "[📋Todoon] [DEBUG] [$tag] $message";
  static String error({required String tag, required String message}) =>
      "[📋Todoon] [ERROR] [$tag] $message";
  static String info({required String tag, required String message}) =>
      "[📋Todoon] [INFO] [$tag] $message";
  static String warning({required String tag, required String message}) =>
      "[📋Todoon] [WARNING] [$tag] $message";
}
