import 'package:EcoSentinel/core/theme/colors.dart';
import 'package:flutter/material.dart';

class LocationPicker extends StatelessWidget {
  final String? location;
  final VoidCallback onPickLocation;
  final VoidCallback? onClear;

  const LocationPicker({
    Key? key,
    required this.location,
    required this.onPickLocation,
    this.onClear,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPickLocation,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.unGray),
        ),
        child: Row(
          children: [
            const Icon(Icons.location_on, color: Colors.blueGrey),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                location?.isNotEmpty == true ? location! : 'Pick a location',
                style: TextStyle(
                  color: location?.isNotEmpty == true
                      ? Colors.black87
                      : Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (location?.isNotEmpty == true && onClear != null)
              IconButton(
                icon: const Icon(Icons.clear, size: 20),
                onPressed: onClear,
                splashRadius: 18,
              ),
            const Icon(Icons.arrow_forward_ios,
                size: 16, color: AppColors.unGray),
          ],
        ),
      ),
    );
  }
}
