
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mqs_content_portal/constants/constants.dart';
import 'package:super_extensions/super_extensions.dart';

class MqsTextField extends StatelessWidget {
  /// A customizable text field with optional features such as hint text, controller,
  /// obscuring the text, read-only mode, custom prefix and suffix widgets, and rounded or square appearance.
  ///
  /// Use this widget when you need a text input field with the flexibility to customize various aspects
  /// such as appearance, behavior, and callbacks.
  ///
  /// Creates a [MqsTextField].
  ///
  /// The [hintText] parameter specifies the text displayed when the field is empty.
  /// The [controller] parameter allows controlling and retrieving the text input.
  /// The [onChanged] callback is triggered when the text in the field changes.
  /// The [onFieldSubmitted] callback is triggered when the user submits the field.
  /// The [isObscured] parameter determines whether the text should be obscured (e.g., for passwords).
  /// The [prefix] and [suffix] parameters allow adding custom widgets before and after the input.
  /// The [readOnly] parameter sets the field to read-only mode if true.
  /// The [width] parameter defines the width of the text field.
  /// The [isRounded] parameter determines whether the text field has a rounded appearance.
  const MqsTextField({
    super.key,
    this.hintText,
    this.controller,
    this.isObscured = false,
    this.readOnly = false,
    this.isRounded = false,
    this.validator,
    this.keyboardType,
    this.prefix,
    this.suffix,
    this.onChanged,
    this.onFieldSubmitted,
    this.width,
    this.maxLength,
    this.autoValidateMode,
    this.textInputAction,
    this.maxLines,
    this.showCounter,
    this.inputFormatters,
    this.focusNode,
    this.onTap,
    this.textAlign,
  });

  /// The text displayed when the field is empty.
  final String? hintText;

  /// Controller for interacting with the text field.
  final TextEditingController? controller;

  /// Callback triggered when the text in the field changes.
  final void Function(String)? onChanged;

  /// validation of the textFiled.
  final String? Function(String?)? validator;

  /// Callback triggered when the user submits the field.
  final void Function(String)? onFieldSubmitted;

  /// Determines whether the text should be obscured (e.g., for passwords).
  final bool isObscured;

  /// Custom widget to be displayed before the input.
  final Widget? prefix;

  /// Custom widget to be displayed after the input.
  final Widget? suffix;

  /// Sets the field to read-only mode if true.
  final bool readOnly;

  /// Width of the text field. If not specified, it takes the screen width.
  final double? width;

  /// Determines whether the text field has a rounded appearance.
  final bool isRounded;

  ///Keyboard text input action
  final TextInputType? keyboardType;

  ///Maximum text length
  final int? maxLength;

  ///Auto Validation mode
  final AutovalidateMode? autoValidateMode;

  ///Input action
  final TextInputAction? textInputAction;

  ///max lines
  final int? maxLines;

  /// shows the counter for character
  final bool? showCounter;

  final List<TextInputFormatter>? inputFormatters;

  final FocusNode? focusNode;

  final VoidCallback? onTap;

  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? context.screenWidth,
      child: TextFormField(
        onTap: onTap,
        focusNode: focusNode,
        readOnly: readOnly,
        onChanged: onChanged,
        inputFormatters: inputFormatters,
        onFieldSubmitted: onFieldSubmitted,
        obscureText: isObscured,
        keyboardType: keyboardType,
        controller: controller,
        validator: validator,
        maxLength: maxLength,
        maxLines: maxLines,
        autovalidateMode:
            autoValidateMode ?? AutovalidateMode.onUserInteraction,
        textInputAction: textInputAction,
        textAlign: textAlign ?? TextAlign.start,
        style: readOnly
            ? const TextStyle(
                color: ColorConstants.kHintTextColor,
              )
            : null,
        decoration: isRounded
            ? StyleConstants.kTextFieldDecoration(
                hintText: hintText,
                prefix: prefix,
                suffix: suffix,
                showCounter: showCounter,
              )
            : StyleConstants.kSqTextFieldDecoration(
                hintText: hintText,
                prefix: prefix,
                suffix: suffix,
                showCounter: showCounter,
              ),
      ),
    );
  }
}
