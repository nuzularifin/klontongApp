import 'package:flutter/widgets.dart';

class ScreenSizeConfig {
  static final ScreenSizeConfig _instance = ScreenSizeConfig._internal();

  // Screen properties
  late double screenWidth;
  late double screenHeight;
  late double blockSizeHorizontal;
  late double blockSizeVertical;

  late double textMultiplier;
  late double imageSizeMultiplier;
  late double heightMultiplier;

  late double safeAreaHorizontal;
  late double safeAreaVertical;
  late double safeBlockHorizontal;
  late double safeBlockVertical;

  // Factory constructor to return the same instance every time
  factory ScreenSizeConfig() {
    return _instance;
  }

  ScreenSizeConfig._internal();

  // Initialize the config using MediaQueryData
  void init(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    screenWidth = mediaQueryData.size.width;
    screenHeight = mediaQueryData.size.height;

    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;

    // Calculate text and image multipliers for scaling
    textMultiplier = blockSizeVertical;
    imageSizeMultiplier = blockSizeHorizontal;
    heightMultiplier = blockSizeVertical;

    // Safe areas (like for notches or status bars)
    safeAreaHorizontal =
        mediaQueryData.padding.left + mediaQueryData.padding.right;
    safeAreaVertical =
        mediaQueryData.padding.top + mediaQueryData.padding.bottom;

    // Safe blocks for safe content scaling
    safeBlockHorizontal = (screenWidth - safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight - safeAreaVertical) / 100;
  }
}
