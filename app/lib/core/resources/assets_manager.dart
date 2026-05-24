// ignore_for_file: constant_identifier_names

const String ICON_PATH = "assets/icons";
const String IMAGE_PATH = "assets/images";
const String LOTTIE_PATH = "assets/lotties";
const String TERMS_AND_PRIVACY_PATH = "assets/termsaprivacy";

class IconAssets {
  IconAssets._();

  static const String todoon_ico = "$ICON_PATH/todoon_256.ico";
  static const String todoon_border_ico = "$ICON_PATH/todoon_border_256.ico";
  static const String todoon_svg = "$ICON_PATH/todoon.svg";
}

class ImageAssets {
  ImageAssets._();

  static const String banner = "$IMAGE_PATH/banner.png";
  static const String todoon_png = "$IMAGE_PATH/todoon_512.png";
  static const String background_light = "$IMAGE_PATH/background_light.png";
  static const String background_dark = "$IMAGE_PATH/background_dark.png";
  static const String bgr_light = "$IMAGE_PATH/bgr_light.png";
  static const String bgr_dark = "$IMAGE_PATH/bgr_dark.png";
  static const String todoon_rounded_png = "$IMAGE_PATH/todoon_rounded_512.png";
  static const String todoon_border_png = "$IMAGE_PATH/todoon_border_256.png";
}

class LottieAssets {
  LottieAssets._();

  static const String cat_loading = "$LOTTIE_PATH/cat_loading.json";
  static const String cat_typing = "$LOTTIE_PATH/cat_typing.json";
  static const String cat_error = "$LOTTIE_PATH/cat_error.json";
  static const String cat_empty = "$LOTTIE_PATH/cat_empty.json";
  static const String cat_idle = "$LOTTIE_PATH/cat_idle.json";

  static const String do_work = "$LOTTIE_PATH/do_work.json";
  static const String no_task = "$LOTTIE_PATH/no_task.json";
  static const String today = "$LOTTIE_PATH/today.json";
}

class TermsAndPrivacyAssets {
  TermsAndPrivacyAssets._();

  static const String privacyPolicy =
      "$TERMS_AND_PRIVACY_PATH/PRIVACY_POLICY.md";
  static const String termsOfService =
      "$TERMS_AND_PRIVACY_PATH/TERMS_OF_SERVICE.md";
}
