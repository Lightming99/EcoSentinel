// lib/features/report_incident/widgets/report_status_chip.dart

import 'package:EcoSentinel/core/theme/colors.dart';
import 'package:EcoSentinel/core/theme/text_styles.dart';
import 'package:EcoSentinel/shared/models/incident_report.dart';
import 'package:flutter/material.dart';

class ReportStatusChip extends StatelessWidget {
  final ReportStatus status;

  const ReportStatusChip({
    Key? key,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    String label;

    switch (status) {
      case ReportStatus.pending:
        backgroundColor = AppColors.unOrange.withOpacity(0.2);
        textColor = AppColors.unOrange;
        label = 'Pending';
        break;
      case ReportStatus.inProgress:
        backgroundColor = AppColors.unBlue.withOpacity(0.2);
        textColor = AppColors.unBlue;
        label = 'In Progress';
        break;
      case ReportStatus.resolved:
        backgroundColor = AppColors.unGreen.withOpacity(0.2);
        textColor = AppColors.unGreen;
        label = 'Resolved';
        break;
      case ReportStatus.rejected:
        backgroundColor = AppColors.unRed.withOpacity(0.2);
        textColor = AppColors.unRed;
        label = 'Rejected';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: AppTextStyles.bodySmall.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
