// lib/shared/widgets/error_widget.dart

import 'package:flutter/material.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/text_styles.dart';

class CustomErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final String? retryText;
  final IconData? icon;
  final bool showIcon;

  const CustomErrorWidget({
    Key? key,
    required this.message,
    this.onRetry,
    this.retryText,
    this.icon,
    this.showIcon = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Error Icon
            if (showIcon) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.unRed.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon ?? Icons.error_outline,
                  size: 48,
                  color: AppColors.unRed,
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Error Title
            Text(
              'Oops! Something went wrong',
              style: AppTextStyles.heading3.copyWith(
                color: AppColors.unDarkGray,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            // Error Message
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.unGray,
              ),
              textAlign: TextAlign.center,
            ),

            // Retry Button
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(retryText ?? 'Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.unBlue,
                  foregroundColor: AppColors.unWhite,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
