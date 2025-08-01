// lib/features/report_incident/widgets/photo_upload.dart

import 'package:flutter/material.dart';
import 'dart:io';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';

class PhotoUpload extends StatelessWidget {
  final List<File> photos;
  final Function() onAddPhoto;
  final Function(File) onRemovePhoto;

  const PhotoUpload({
    Key? key,
    required this.photos,
    required this.onAddPhoto,
    required this.onRemovePhoto,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Add Photos',
          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Container(
          height: 120,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              // Add Photo Button
              GestureDetector(
                onTap: onAddPhoto,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.unLightGray,
                      style: BorderStyle.solid,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_a_photo,
                        size: 32,
                        color: AppColors.unGray,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Add Photo',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.unGray,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Photo List
              ...photos.map((photo) => Container(
                    margin: const EdgeInsets.only(left: 8),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            photo,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () => onRemovePhoto(photo),
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: const BoxDecoration(
                                color: AppColors.unRed,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: AppColors.unWhite,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }
}
