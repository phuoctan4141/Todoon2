const EMPTY = '';
const iZERO = 0;
const dZERO = 0.0;

const Duration kSplashDelay = Duration(seconds: 3);
const Duration kRefreshDelay = Duration(seconds: 5);

extension NonNullString on String? {
  String orEmpty() => this ?? EMPTY;
}

extension NonNullInteger on int? {
  int orZero() => this ?? iZERO;
}

extension NonNullDouble on double? {
  double orZero() => this ?? dZERO;
}
