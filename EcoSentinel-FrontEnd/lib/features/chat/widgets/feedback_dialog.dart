import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';

class FeedbackDialog extends StatefulWidget {
  final Function(String? comment, List<String>? categories) onSubmit;

  const FeedbackDialog({
    super.key,
    required this.onSubmit,
  });

  @override
  State<FeedbackDialog> createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<FeedbackDialog> {
  final TextEditingController _commentController = TextEditingController();
  final Set<String> _selectedCategories = {};

  final List<String> _feedbackCategories = [
    'Incorrect information',
    'Not helpful',
    'Unclear response',
    'Missing information',
    'Technical error',
    'Inappropriate content',
    'Other',
  ];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Help us improve',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'What went wrong with this response?',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),

            // Category chips
            const Text(
              'Select all that apply:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: _feedbackCategories.map((category) {
                final isSelected = _selectedCategories.contains(category);
                return FilterChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedCategories.add(category);
                      } else {
                        _selectedCategories.remove(category);
                      }
                    });
                  },
                  selectedColor: UNColors.unBlue.withOpacity(0.2),
                  checkmarkColor: UNColors.unBlue,
                  labelStyle: TextStyle(
                    color: isSelected ? UNColors.unBlue : Colors.black87,
                    fontSize: 12,
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            // Comment field
            const Text(
              'Additional feedback (optional):',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _commentController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Tell us more about what went wrong...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: UNColors.unLightGray),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      const BorderSide(color: UNColors.unBlue, width: 2),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'Cancel',
            style: TextStyle(color: UNColors.unGray),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            final comment = _commentController.text.trim();
            final categories = _selectedCategories.toList();

            widget.onSubmit(
              comment.isEmpty ? null : comment,
              categories.isEmpty ? null : categories,
            );
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: UNColors.unBlue,
            foregroundColor: UNColors.unWhite,
          ),
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
