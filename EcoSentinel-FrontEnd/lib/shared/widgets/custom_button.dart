// lib/shared/widgets/custom_button.dart
import 'package:flutter/material.dart';
import '../../core/theme/colors.dart';

enum ButtonType {
  primary,
  secondary,
  outlined,
  text,
  danger,
  success,
}

enum ButtonSize {
  small,
  medium,
  large,
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final ButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final Color? customColor;
  final Color? customTextColor;
  final EdgeInsetsGeometry? customPadding;
  final double? customBorderRadius;
  final bool enabled;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.size = ButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.customColor,
    this.customTextColor,
    this.customPadding,
    this.customBorderRadius,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: _buildButton(context),
    );
  }

  Widget _buildButton(BuildContext context) {
    final bool isEnabled = enabled && onPressed != null && !isLoading;

    switch (type) {
      case ButtonType.primary:
        return ElevatedButton(
          onPressed: isEnabled ? onPressed : null,
          style: _getPrimaryButtonStyle(),
          child: _buildButtonContent(),
        );
      case ButtonType.secondary:
        return ElevatedButton(
          onPressed: isEnabled ? onPressed : null,
          style: _getSecondaryButtonStyle(),
          child: _buildButtonContent(),
        );
      case ButtonType.outlined:
        return OutlinedButton(
          onPressed: isEnabled ? onPressed : null,
          style: _getOutlinedButtonStyle(),
          child: _buildButtonContent(),
        );
      case ButtonType.text:
        return TextButton(
          onPressed: isEnabled ? onPressed : null,
          style: _getTextButtonStyle(),
          child: _buildButtonContent(),
        );
      case ButtonType.danger:
        return ElevatedButton(
          onPressed: isEnabled ? onPressed : null,
          style: _getDangerButtonStyle(),
          child: _buildButtonContent(),
        );
      case ButtonType.success:
        return ElevatedButton(
          onPressed: isEnabled ? onPressed : null,
          style: _getSuccessButtonStyle(),
          child: _buildButtonContent(),
        );
    }
  }

  Widget _buildButtonContent() {
    if (isLoading) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: _getLoadingSize(),
            height: _getLoadingSize(),
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                _getLoadingColor(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Loading...',
            style: TextStyle(
              fontSize: _getFontSize(),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: _getIconSize(),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: _getFontSize(),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }

    return Text(
      text,
      style: TextStyle(
        fontSize: _getFontSize(),
        fontWeight: FontWeight.w600,
      ),
    );
  }

  ButtonStyle _getPrimaryButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: customColor ?? UNColors.unBlue,
      foregroundColor: customTextColor ?? Colors.white,
      padding: customPadding ?? _getPadding(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(customBorderRadius ?? 12),
      ),
      elevation: 2,
      shadowColor: Colors.black26,
      disabledBackgroundColor: Colors.grey[300],
      disabledForegroundColor: Colors.grey[600],
      minimumSize: Size(0, _getMinHeight()),
    ).copyWith(
      overlayColor: WidgetStateProperty.resolveWith<Color?>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.pressed)) {
            return Colors.white.withOpacity(0.1);
          }
          if (states.contains(WidgetState.hovered)) {
            return Colors.white.withOpacity(0.05);
          }
          return null;
        },
      ),
    );
  }

  ButtonStyle _getSecondaryButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: customColor ?? UNColors.unLightGray,
      foregroundColor: customTextColor ?? UNColors.unBlue,
      padding: customPadding ?? _getPadding(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(customBorderRadius ?? 12),
      ),
      elevation: 1,
      shadowColor: Colors.black12,
      disabledBackgroundColor: Colors.grey[200],
      disabledForegroundColor: Colors.grey[500],
      minimumSize: Size(0, _getMinHeight()),
    );
  }

  ButtonStyle _getOutlinedButtonStyle() {
    return OutlinedButton.styleFrom(
      foregroundColor: customTextColor ?? UNColors.unBlue,
      backgroundColor: customColor,
      padding: customPadding ?? _getPadding(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(customBorderRadius ?? 12),
      ),
      side: BorderSide(
        color: customColor ?? UNColors.unBlue,
        width: 1.5,
      ),
      minimumSize: Size(0, _getMinHeight()),
    ).copyWith(
      side: WidgetStateProperty.resolveWith<BorderSide?>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return BorderSide(
              color: Colors.grey[400]!,
              width: 1.5,
            );
          }
          return BorderSide(
            color: customColor ?? UNColors.unBlue,
            width: 1.5,
          );
        },
      ),
    );
  }

  ButtonStyle _getTextButtonStyle() {
    return TextButton.styleFrom(
      foregroundColor: customTextColor ?? UNColors.unBlue,
      backgroundColor: customColor,
      padding: customPadding ?? _getPadding(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(customBorderRadius ?? 12),
      ),
      minimumSize: Size(0, _getMinHeight()),
    );
  }

  ButtonStyle _getDangerButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: customColor ?? UNColors.unRed,
      foregroundColor: customTextColor ?? Colors.white,
      padding: customPadding ?? _getPadding(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(customBorderRadius ?? 12),
      ),
      elevation: 2,
      shadowColor: Colors.black26,
      disabledBackgroundColor: Colors.grey[300],
      disabledForegroundColor: Colors.grey[600],
      minimumSize: Size(0, _getMinHeight()),
    );
  }

  ButtonStyle _getSuccessButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: customColor ?? UNColors.unGreen,
      foregroundColor: customTextColor ?? Colors.white,
      padding: customPadding ?? _getPadding(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(customBorderRadius ?? 12),
      ),
      elevation: 2,
      shadowColor: Colors.black26,
      disabledBackgroundColor: Colors.grey[300],
      disabledForegroundColor: Colors.grey[600],
      minimumSize: Size(0, _getMinHeight()),
    );
  }

  EdgeInsetsGeometry _getPadding() {
    switch (size) {
      case ButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
      case ButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 12);
      case ButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 32, vertical: 16);
    }
  }

  double _getMinHeight() {
    switch (size) {
      case ButtonSize.small:
        return 36;
      case ButtonSize.medium:
        return 44; // UN accessibility minimum touch target
      case ButtonSize.large:
        return 52;
    }
  }

  double _getFontSize() {
    switch (size) {
      case ButtonSize.small:
        return 14;
      case ButtonSize.medium:
        return 16;
      case ButtonSize.large:
        return 18;
    }
  }

  double _getIconSize() {
    switch (size) {
      case ButtonSize.small:
        return 16;
      case ButtonSize.medium:
        return 20;
      case ButtonSize.large:
        return 24;
    }
  }

  double _getLoadingSize() {
    switch (size) {
      case ButtonSize.small:
        return 14;
      case ButtonSize.medium:
        return 16;
      case ButtonSize.large:
        return 18;
    }
  }

  Color _getLoadingColor() {
    switch (type) {
      case ButtonType.primary:
      case ButtonType.danger:
      case ButtonType.success:
        return Colors.white;
      case ButtonType.secondary:
      case ButtonType.outlined:
      case ButtonType.text:
        return customTextColor ?? UNColors.unBlue;
    }
  }
}

// Extension for easy button creation
extension CustomButtonExtension on Widget {
  Widget withCustomButton({
    required String text,
    required VoidCallback? onPressed,
    ButtonType type = ButtonType.primary,
    ButtonSize size = ButtonSize.medium,
    IconData? icon,
    bool isLoading = false,
    bool isFullWidth = false,
  }) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      type: type,
      size: size,
      icon: icon,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
    );
  }
}

// Helper class for common button configurations
class UNButtons {
  // Primary action button
  static Widget primary({
    required String text,
    required VoidCallback? onPressed,
    IconData? icon,
    ButtonSize size = ButtonSize.medium,
    bool isLoading = false,
    bool isFullWidth = false,
  }) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      type: ButtonType.primary,
      size: size,
      icon: icon,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
    );
  }

  // Secondary action button
  static Widget secondary({
    required String text,
    required VoidCallback? onPressed,
    IconData? icon,
    ButtonSize size = ButtonSize.medium,
    bool isLoading = false,
    bool isFullWidth = false,
  }) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      type: ButtonType.secondary,
      size: size,
      icon: icon,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
    );
  }

  // Outlined button
  static Widget outlined({
    required String text,
    required VoidCallback? onPressed,
    IconData? icon,
    ButtonSize size = ButtonSize.medium,
    bool isLoading = false,
    bool isFullWidth = false,
  }) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      type: ButtonType.outlined,
      size: size,
      icon: icon,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
    );
  }

  // Danger/destructive action button
  static Widget danger({
    required String text,
    required VoidCallback? onPressed,
    IconData? icon,
    ButtonSize size = ButtonSize.medium,
    bool isLoading = false,
    bool isFullWidth = false,
  }) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      type: ButtonType.danger,
      size: size,
      icon: icon,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
    );
  }

  // Success/positive action button
  static Widget success({
    required String text,
    required VoidCallback? onPressed,
    IconData? icon,
    ButtonSize size = ButtonSize.medium,
    bool isLoading = false,
    bool isFullWidth = false,
  }) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      type: ButtonType.success,
      size: size,
      icon: icon,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
    );
  }

  // Text-only button
  static Widget text({
    required String text,
    required VoidCallback? onPressed,
    IconData? icon,
    ButtonSize size = ButtonSize.medium,
    bool isLoading = false,
  }) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      type: ButtonType.text,
      size: size,
      icon: icon,
      isLoading: isLoading,
    );
  }
}
