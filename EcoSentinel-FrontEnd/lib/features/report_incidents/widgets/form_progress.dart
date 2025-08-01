// lib/features/report_incident/widgets/form_progress.dart

import 'dart:ui';
import 'package:EcoSentinel/core/theme/colors.dart';
import 'package:EcoSentinel/core/theme/text_styles.dart';
import 'package:flutter/material.dart';

class FormProgress extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<String> stepLabels;

  const FormProgress({
    Key? key,
    required this.currentStep,
    required this.totalSteps,
    required this.stepLabels,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Progress Bar
          Row(
            children: List.generate(totalSteps, (index) {
              final isCompleted = index < currentStep;
              final isCurrent = index == currentStep;

              return Expanded(
                child: Container(
                  height: 4,
                  margin:
                      EdgeInsets.only(right: index < totalSteps - 1 ? 4 : 0),
                  decoration: BoxDecoration(
                    color: isCompleted || isCurrent
                        ? AppColors.unBlue
                        : AppColors.unLightGray,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 8),

          // Step Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(totalSteps, (index) {
              final isCompleted = index < currentStep;
              final isCurrent = index == currentStep;

              return Column(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? AppColors.unBlue
                          : isCurrent
                              ? AppColors.unBlue
                              : AppColors.unLightGray,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: isCompleted
                          ? const Icon(
                              Icons.check,
                              color: AppColors.unWhite,
                              size: 16,
                            )
                          : Text(
                              '${index + 1}',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: isCurrent
                                    ? AppColors.unWhite
                                    : AppColors.unGray,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    stepLabels[index],
                    style: AppTextStyles.caption.copyWith(
                      color: isCurrent ? AppColors.unBlue : AppColors.unGray,
                      fontWeight:
                          isCurrent ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
