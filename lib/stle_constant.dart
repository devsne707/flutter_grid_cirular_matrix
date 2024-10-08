import 'package:flutter/material.dart';
import 'package:mqs_content_portal/constants/constants.dart';

/// A class containing static [TextStyle] and [InputDecoration] constants
/// for maintaining consistent styles across the application.
class StyleConstants {
  // App Title Text
  static const TextStyle kAppTitleTextStyle = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 40.0,
    fontWeight: FontWeight.w500,
    color: ColorConstants.kG5AppPaletteGreen,
  );

  // App Sub Title Text
  static const TextStyle kAppSubtitleTextStyle = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 24.0,
    fontWeight: FontWeight.w500,
    color: ColorConstants.kDarkForeground,
    letterSpacing: 2,
  );

  // App Header Text
  static const TextStyle kAppHeaderTextStyle = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 20.0,
    fontWeight: FontWeight.w500,
    color: ColorConstants.kAppNormalTextLightBG,
    letterSpacing: 1.2,
    textBaseline: TextBaseline.alphabetic,
  );

  // App Version Text
  static const TextStyle kAppVersionTextStyle = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 12.0,
    fontWeight: FontWeight.w500,
    color: ColorConstants.kAppNormalTextLightBG,
    letterSpacing: 0.8,
    textBaseline: TextBaseline.alphabetic,
  );

  // App Button Text - No Background
  static const TextStyle kAppButtonNBGTextStyle = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    color: ColorConstants.kDarkBackground,
  );

  // App Text - Text Fields
  static const TextStyle kAppTextFieldText = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    color: ColorConstants.kDarkBackground,
    letterSpacing: 1.2,
  );

  /* 
    INPUT DECORATION
  */

  /// Returns a standardized [InputDecoration] for regular text fields.
  static InputDecoration kTextFieldDecoration({
    String? hintText,
    Widget? prefix,
    Widget? suffix,
    bool? showCounter,
  }) =>
      InputDecoration(
        prefixIcon: prefix,
        suffixIcon: suffix,
        isDense: true,
        counterText: (showCounter ?? false) ? null : '',
        label: Text(
          hintText ?? '',
          style: const TextStyle(
            color: ColorConstants.kHintTextColor,
          ),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        hintStyle: const TextStyle(
          color: ColorConstants.kHintTextColor,
        ),
        errorStyle: const TextStyle(
          color: ColorConstants.errorCodeColor,
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide:
              BorderSide(color: ColorConstants.kLightForeground, width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide:
              BorderSide(color: ColorConstants.errorCodeColor, width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide:
              BorderSide(color: ColorConstants.errorCodeColor, width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide:
              BorderSide(color: ColorConstants.kLightForeground, width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
      );

  /// Returns a standardized [InputDecoration] for square-shaped text fields.
  static InputDecoration kSqTextFieldDecoration(
          {String? hintText,
          Widget? prefix,
          Widget? suffix,
          bool? showCounter}) =>
      InputDecoration(
        prefixIcon: prefix,
        suffixIcon: suffix,
        counterText: (showCounter ?? false) ? null : '',
        label: Text(
          hintText ?? '',
          style: const TextStyle(
            color: ColorConstants.kHintTextColor,
          ),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        hintStyle: const TextStyle(
          color: ColorConstants.kHintTextColor,
        ),
        errorStyle: const TextStyle(
          color: ColorConstants.errorCodeColor,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 20.0,
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(2.0),
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            //color: ColorConstants.kLightBorder,
            color: Colors.grey,
            width: 1.0,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(2.0),
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: ColorConstants.kLightForeground,
            width: 1.0,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(2.0),
          ),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide:
              BorderSide(color: ColorConstants.errorCodeColor, width: 1.0),
          borderRadius: BorderRadius.all(
            Radius.circular(2.0),
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide:
              BorderSide(color: ColorConstants.errorCodeColor, width: 1.0),
          borderRadius: BorderRadius.all(
            Radius.circular(2.0),
          ),
        ),
      );

  /// Returns a standardized [InputDecoration] for text fields with an underline design.
  static InputDecoration kUnderLineTextFieldDecoration({
    String? hintText,
    Widget? prefix,
    Widget? suffix,
  }) =>
      InputDecoration(
        prefix: prefix,
        suffix: suffix,
        hintText: hintText ?? 'Enter a value',
        hintStyle: const TextStyle(
          color: ColorConstants.kHintTextColor,
        ),
        errorStyle: const TextStyle(
          color: ColorConstants.errorCodeColor,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
        border: const UnderlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(2.0)),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide:
              BorderSide(color: ColorConstants.kLightBorder, width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(2.0)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide:
              BorderSide(color: ColorConstants.kLightForeground, width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(2.0)),
        ),
      );
}
