// lib/shared/widgets/custom_card.dart

import 'package:flutter/material.dart';
import '../../core/theme/colors.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double elevation;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;
  final bool hasShadow;

  const CustomCard({
    Key? key,
    required this.child,
    this.margin,
    this.padding,
    this.elevation = 2.0,
    this.backgroundColor,
    this.borderRadius,
    this.onTap,
    this.hasShadow = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.all(0),
      child: Material(
        elevation: hasShadow ? elevation : 0,
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        color: backgroundColor ?? AppColors.unWhite,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius ?? BorderRadius.circular(12),
          child: Container(
            padding: padding ?? const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: borderRadius ?? BorderRadius.circular(12),
              border: hasShadow
                  ? null
                  : Border.all(
                      color: AppColors.unLightGray,
                      width: 1,
                    ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
