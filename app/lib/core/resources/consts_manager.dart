const EMPTY = '';
const iZERO = 0;
const dZERO = 0.0;

// Time durations
const Duration kSplashDelay = Duration(seconds: 3);
const Duration kRefreshDelay = Duration(seconds: 5);
// Timeout duration for network operations
const Duration kRequestTimeout = Duration(seconds: 10);

const double kBottomBarHeight = 90.0;

extension NonNullString on String? {
  String orEmpty() => this ?? EMPTY;
}

extension NonNullInteger on int? {
  int orZero() => this ?? iZERO;
}

extension NonNullDouble on double? {
  double orZero() => this ?? dZERO;
}
