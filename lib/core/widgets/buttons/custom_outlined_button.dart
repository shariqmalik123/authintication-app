import 'package:flutter/material.dart';
import '../../theme/app_border_radius.dart';
import '../../theme/app_colors.dart';

class CustomOutlinedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final double? height;
  final double? width;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final TextStyle? textStyle;
  final Widget? icon;
  final List<BoxShadow>? boxShadow;
  final bool isLoading;

  const CustomOutlinedButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.height,
    this.width,
    this.foregroundColor,
    this.backgroundColor,
    this.borderRadius,
    this.textStyle,
    this.icon,
    this.boxShadow,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? AppBorderRadius.md,
        boxShadow: boxShadow,
      ),
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: foregroundColor ?? AppColors.primary,
          backgroundColor: backgroundColor ?? Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? AppBorderRadius.md,
          ),
          side: BorderSide(
            color: foregroundColor ?? AppColors.primary,
            width: 1.5,
          ),
        ),
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    foregroundColor ?? AppColors.primary,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[icon!, const SizedBox(width: 8)],
                  Text(text, style: textStyle),
                ],
              ),
      ),
    );
  }
}
