import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../client.dart';
import '../ui/ui.dart';

/// A reusable photo picker widget that supports camera capture and gallery
/// selection. Uploads the photo to Serverpod cloud storage and returns the URL.
class PhotoPickerWidget extends StatefulWidget {
  final String? initialImageUrl;
  final ValueChanged<String?> onImageChanged;

  const PhotoPickerWidget({
    super.key,
    this.initialImageUrl,
    required this.onImageChanged,
  });

  @override
  State<PhotoPickerWidget> createState() => _PhotoPickerWidgetState();
}

class _PhotoPickerWidgetState extends State<PhotoPickerWidget>
    with SingleTickerProviderStateMixin {
  final ImagePicker _picker = ImagePicker();

  String? _imageUrl;
  Uint8List? _localPreviewBytes;
  bool _isUploading = false;
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _imageUrl = widget.initialImageUrl;
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );

      if (pickedFile == null) return;

      final bytes = await pickedFile.readAsBytes();

      setState(() {
        _localPreviewBytes = bytes;
        _isUploading = true;
      });

      // Upload to Serverpod backend
      try {
        final base64Data = base64Encode(bytes);
        final filename = pickedFile.name.isNotEmpty
            ? pickedFile.name
            : 'photo_${DateTime.now().millisecondsSinceEpoch}.jpg';

        final url = await client.report.uploadPhoto(
          filename: filename,
          base64Data: base64Data,
        );

        setState(() {
          _imageUrl = url;
          _isUploading = false;
        });

        widget.onImageChanged(url);
      } catch (e) {
        // Fallback: use data URL for local preview
        final dataUrl = 'data:image/jpeg;base64,${base64Encode(bytes)}';
        setState(() {
          _imageUrl = dataUrl;
          _isUploading = false;
        });
        widget.onImageChanged(dataUrl);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Photo saved locally. Upload failed: $e'),
              backgroundColor: context.colors.warning,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Could not access ${source == ImageSource.camera ? 'camera' : 'gallery'}: $e',
            ),
            backgroundColor: context.colors.error,
          ),
        );
      }
    }
  }

  void _removePhoto() {
    setState(() {
      _imageUrl = null;
      _localPreviewBytes = null;
    });
    widget.onImageChanged(null);
  }

  void _showPickerSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: context.colors.line,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                'Add Photo',
                style: AppText.h3(context.colors.ink),
              ),
              AppSpacing.gap24,
              // Camera option
              if (!kIsWeb) ...[
                _buildPickerOption(
                  context,
                  icon: Icons.camera_alt_rounded,
                  label: 'Take a Photo',
                  subtitle: 'Open camera to capture the item',
                  color: context.colors.brand,
                  onTap: () {
                    Navigator.of(ctx).pop();
                    _pickImage(ImageSource.camera);
                  },
                ),
                AppSpacing.gap12,
              ],
              // Gallery option
              _buildPickerOption(
                context,
                icon: Icons.photo_library_rounded,
                label: 'Choose from Gallery',
                subtitle: 'Select an existing photo from your device',
                color: context.colors.success,
                onTap: () {
                  Navigator.of(ctx).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
              AppSpacing.gap12,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPickerOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.panelBr,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s16,
            vertical: AppSpacing.s12,
          ),
          decoration: BoxDecoration(
            color: color.withAlpha(15),
            borderRadius: AppRadius.panelBr,
            border: Border.all(color: color.withAlpha(45)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withAlpha(30),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              AppSpacing.hGap16,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: AppText.label(context.colors.ink),
                    ),
                    AppSpacing.gap4,
                    Text(
                      subtitle,
                      style: AppText.caption(context.colors.muted),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: color, size: 22),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreviewImage(BuildContext context) {
    if (_localPreviewBytes != null) {
      return Image.memory(
        _localPreviewBytes!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }
    if (_imageUrl != null && _imageUrl!.startsWith('http')) {
      return Image.network(
        _imageUrl!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (_, __, ___) => _buildPlaceholderIcon(context),
      );
    }
    return _buildPlaceholderIcon(context);
  }

  Widget _buildPlaceholderIcon(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.photo_camera_rounded, size: 40, color: context.colors.muted),
        AppSpacing.gap8,
        Text(
          'No photo yet',
          style: AppText.caption(context.colors.muted),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = _imageUrl != null || _localPreviewBytes != null;
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Photo (Optional)',
          style: AppText.label(colors.ink),
        ),
        AppSpacing.gap8,
        GestureDetector(
          onTap: _isUploading ? null : _showPickerSheet,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: hasImage ? 200 : 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: AppRadius.panelBr,
              border: Border.all(
                color: _isUploading
                    ? colors.brand.withAlpha(100)
                    : hasImage
                    ? colors.success.withAlpha(100)
                    : colors.line,
                width: _isUploading ? 2.0 : 1.0,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                // Image preview or placeholder
                if (hasImage)
                  _buildPreviewImage(context)
                else
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: colors.brand.withAlpha(20),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.add_a_photo_rounded,
                            size: 28,
                            color: colors.brand,
                          ),
                        ),
                        AppSpacing.gap8,
                        Text(
                          kIsWeb
                              ? 'Tap to select a photo'
                              : 'Tap to take or select a photo',
                          style: AppText.caption(colors.brand).copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                // Upload progress overlay
                if (_isUploading)
                  Container(
                    color: colors.scrim,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 32,
                            height: 32,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: colors.onImage,
                            ),
                          ),
                          AppSpacing.gap8,
                          Text(
                            'Uploading...',
                            style: AppText.caption(colors.surface).copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Success badge
                if (hasImage && !_isUploading)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: colors.success,
                        borderRadius: AppRadius.pillBr,
                        boxShadow: [
                          BoxShadow(
                            color: colors.scrim.withAlpha(50),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: colors.surface,
                            size: 14,
                          ),
                          AppSpacing.hGap4,
                          Text(
                            'Photo Added',
                            style: AppText.caption(colors.surface).copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Remove button
                if (hasImage && !_isUploading)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _removePhoto,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: colors.scrim,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close,
                            color: colors.onImage,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ),

                // Replace button
                if (hasImage && !_isUploading)
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _showPickerSheet,
                        borderRadius: AppRadius.pillBr,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: colors.scrim,
                            borderRadius: AppRadius.pillBr,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.refresh,
                                color: colors.onImage,
                                size: 16,
                              ),
                              AppSpacing.hGap4,
                              Text(
                                'Replace',
                                style: AppText.caption(colors.onImage).copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
