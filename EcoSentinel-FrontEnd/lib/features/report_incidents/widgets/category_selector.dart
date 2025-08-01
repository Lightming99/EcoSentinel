// lib/features/report_incident/widgets/category_selector.dart

import 'package:EcoSentinel/core/theme/colors.dart';
import 'package:EcoSentinel/core/theme/text_styles.dart';
import 'package:flutter/material.dart';

class CategorySelector extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const CategorySelector({
    Key? key,
    required this.selectedCategory,
    required this.onCategorySelected,
  }) : super(key: key);

  static const List<Map<String, dynamic>> categories = [
    {'name': 'Air Pollution', 'icon': Icons.air},
    {'name': 'Water Pollution', 'icon': Icons.water_drop},
    {'name': 'Waste Management', 'icon': Icons.delete},
    {'name': 'Noise Pollution', 'icon': Icons.volume_up},
    {'name': 'Illegal Dumping', 'icon': Icons.warning},
    {'name': 'Deforestation', 'icon': Icons.forest},
    {'name': 'Wildlife', 'icon': Icons.pets},
    {'name': 'Chemical Spill', 'icon': Icons.science},
    {'name': 'Construction', 'icon': Icons.construction},
    {'name': 'Traffic', 'icon': Icons.traffic},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: categories.map((category) {
            final isSelected = selectedCategory == category['name'];
            return GestureDetector(
              onTap: () => onCategorySelected(category['name']),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.unBlue : AppColors.unWhite,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color:
                        isSelected ? AppColors.unBlue : AppColors.unLightGray,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      category['icon'],
                      size: 16,
                      color: isSelected ? AppColors.unWhite : AppColors.unGray,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      category['name'],
                      style: AppTextStyles.bodySmall.copyWith(
                        color: isSelected
                            ? AppColors.unWhite
                            : AppColors.unDarkGray,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
