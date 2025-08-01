// lib/features/report_incident/widgets/priority_picker.dart

import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';

class PriorityPicker extends StatelessWidget {
  final String selectedPriority;
  final Function(String) onPrioritySelected;

  const PriorityPicker({
    Key? key,
    required this.selectedPriority,
    required this.onPrioritySelected,
  }) : super(key: key);

  static const List<Map<String, dynamic>> priorities = [
    {
      'name': 'Low',
      'color': AppColors.unGreen,
      'description': 'Non-urgent environmental concern'
    },
    {
      'name': 'Medium',
      'color': AppColors.unOrange,
      'description': 'Moderate environmental impact'
    },
    {
      'name': 'High',
      'color': AppColors.unRed,
      'description': 'Serious environmental threat'
    },
    {
      'name': 'Critical',
      'color': Colors.red,
      'description': 'Immediate environmental emergency'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Priority Level',
          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Column(
          children: priorities.map((priority) {
            final isSelected = selectedPriority == priority['name'];
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: priority['color'],
                    shape: BoxShape.circle,
                  ),
                ),
                title: Text(
                  priority['name'],
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
                subtitle: Text(
                  priority['description'],
                  style: AppTextStyles.bodySmall,
                ),
                trailing: Radio<String>(
                  value: priority['name'],
                  groupValue: selectedPriority,
                  onChanged: (value) => onPrioritySelected(value!),
                  activeColor: AppColors.unBlue,
                ),
                onTap: () => onPrioritySelected(priority['name']),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                tileColor:
                    isSelected ? AppColors.unBlue.withOpacity(0.1) : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
