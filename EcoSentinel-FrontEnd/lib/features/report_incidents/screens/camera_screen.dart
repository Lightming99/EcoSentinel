// lib/features/report_incident/screens/camera_screen.dart

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../shared/widgets/custom_button.dart';

class CameraScreen extends StatefulWidget {
  final Function(List<File>) onPhotosSelected;
  final List<File> existingPhotos;

  const CameraScreen({
    Key? key,
    required this.onPhotosSelected,
    this.existingPhotos = const [],
  }) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  bool _isInitialized = false;
  bool _isLoading = false;
  List<File> _selectedPhotos = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _selectedPhotos = List.from(widget.existingPhotos);
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isNotEmpty) {
        _controller = CameraController(
          _cameras[0],
          ResolutionPreset.high,
          enableAudio: false,
        );
        await _controller!.initialize();
        if (mounted) {
          setState(() {
            _isInitialized = true;
          });
        }
      }
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final XFile photo = await _controller!.takePicture();
      final File imageFile = File(photo.path);

      setState(() {
        _selectedPhotos.add(imageFile);
        _isLoading = false;
      });

      _showPhotoPreview(imageFile);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar('Failed to take photo: $e');
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage();
      if (images.isNotEmpty) {
        final List<File> newPhotos =
            images.map((image) => File(image.path)).toList();
        setState(() {
          _selectedPhotos.addAll(newPhotos);
        });
      }
    } catch (e) {
      _showErrorSnackBar('Failed to pick images: $e');
    }
  }

  void _showPhotoPreview(File photo) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Photo Preview',
                style: AppTextStyles.heading3,
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  photo,
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedPhotos.remove(photo);
                      });
                      Navigator.of(context).pop();
                    },
                    child: const Text('Remove'),
                  ),
                  CustomButton(
                    text: 'Keep Photo',
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _removePhoto(File photo) {
    setState(() {
      _selectedPhotos.remove(photo);
    });
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.unRed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Photos'),
        backgroundColor: AppColors.unBlue,
        foregroundColor: AppColors.unWhite,
        actions: [
          TextButton(
            onPressed: _selectedPhotos.isNotEmpty
                ? () {
                    widget.onPhotosSelected(_selectedPhotos);
                    Navigator.of(context).pop();
                  }
                : null,
            child: Text(
              'Done (${_selectedPhotos.length})',
              style: TextStyle(
                color: _selectedPhotos.isNotEmpty
                    ? AppColors.unWhite
                    : AppColors.unLightGray,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Camera Preview
          Expanded(
            flex: 3,
            child: _buildCameraPreview(),
          ),

          // Photo Selection Grid
          if (_selectedPhotos.isNotEmpty)
            Expanded(
              flex: 1,
              child: _buildPhotoGrid(),
            ),

          // Controls
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Gallery Button
                IconButton(
                  onPressed: _pickFromGallery,
                  icon: const Icon(Icons.photo_library),
                  iconSize: 32,
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.unLightGray,
                    padding: const EdgeInsets.all(16),
                  ),
                ),

                // Camera Button
                GestureDetector(
                  onTap: _isLoading ? null : _takePicture,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: _isLoading ? AppColors.unGray : AppColors.unBlue,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.unWhite,
                        width: 4,
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: AppColors.unWhite,
                          )
                        : const Icon(
                            Icons.camera_alt,
                            color: AppColors.unWhite,
                            size: 32,
                          ),
                  ),
                ),

                // Switch Camera Button
                IconButton(
                  onPressed: _cameras.length > 1 ? _switchCamera : null,
                  icon: const Icon(Icons.flip_camera_ios),
                  iconSize: 32,
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.unLightGray,
                    padding: const EdgeInsets.all(16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraPreview() {
    if (!_isInitialized) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.unBlue,
        ),
      );
    }

    return Container(
      width: double.infinity,
      child: CameraPreview(_controller!),
    );
  }

  Widget _buildPhotoGrid() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 1.0,
          mainAxisSpacing: 8,
        ),
        itemCount: _selectedPhotos.length,
        itemBuilder: (context, index) {
          final photo = _selectedPhotos[index];
          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  photo,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: GestureDetector(
                  onTap: () => _removePhoto(photo),
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
          );
        },
      ),
    );
  }

  Future<void> _switchCamera() async {
    if (_cameras.length < 2) return;

    final currentCameraIndex = _cameras.indexOf(_controller!.description);
    final nextCameraIndex = (currentCameraIndex + 1) % _cameras.length;

    await _controller!.dispose();
    _controller = CameraController(
      _cameras[nextCameraIndex],
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _controller!.initialize();
    setState(() {});
  }
}
