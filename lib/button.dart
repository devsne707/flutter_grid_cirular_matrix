import 'package:flutter/material.dart';

class MqsElevatedButton extends StatelessWidget {
  /// A customizable elevated button with optional width, height, and background color.
  ///
  /// Use this widget when you need a button with elevated appearance and want to
  /// customize its properties such as onPressed callback, child widget, width,
  /// height, and background color.
  ///
  /// Creates a [MqsElevatedButton].
  ///
  /// The [onPressed] callback is triggered when the button is pressed.
  /// The [child] widget is the content of the button.
  /// The [width] and [height] parameters define the dimensions of the button.
  /// The [backgroundColor] parameter sets the background color of the button.
  const MqsElevatedButton({
    super.key,
    this.onPressed,
    this.child,
    this.width,
    this.height,
    this.backgroundColor,
  });

  /// Callback function triggered when the button is pressed.
  final void Function()? onPressed;

  /// The content of the button.
  final Widget? child;

  /// The width of the button. If not specified, it takes the intrinsic width.
  final double? width;

  /// The height of the button. If not specified, it takes the intrinsic height.
  final double? height;

  /// The background color of the button.
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          shape: const WidgetStatePropertyAll(RoundedRectangleBorder()),
          backgroundColor: WidgetStatePropertyAll(backgroundColor),
        ),
        child: child,
      ),
    );
  }
}
