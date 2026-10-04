import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../../core/constants/constants.dart';
import '../../../../../../core/extensions/build_context_extensions.dart';
import '../../../../../../core/presentation/widgets/widgets.dart';

class PhotoUpdateWidget extends StatefulWidget {
  final String? photoUrl;
  final String initials;
  final ValueChanged<File> onPhotoSelected;
  final VoidCallback onPhotoRemoved;

  const PhotoUpdateWidget({
    super.key,
    this.photoUrl,
    required this.initials,
    required this.onPhotoSelected,
    required this.onPhotoRemoved,
  });

  @override
  State<PhotoUpdateWidget> createState() => _PhotoUpdateWidgetState();
}

class _PhotoUpdateWidgetState extends State<PhotoUpdateWidget> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 400,
        maxHeight: 400,
        imageQuality: 10,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
        widget.onPhotoSelected(_selectedImage!);
      }
    } catch (e, stackTrace) {
      if (mounted) {
        debugPrint('$e');
        debugPrintStack(stackTrace: stackTrace);
        AppSnackBar.error(context, 'Error picking image');
      }
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            if (_selectedImage != null || widget.photoUrl != null)
              ListTile(
                leading: Icon(Icons.delete_outline, color: context.cs.error),
                title: Text(
                  'Remove Photo',
                  style: TextStyle(color: context.cs.error),
                ),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _selectedImage = null;
                  });
                  widget.onPhotoRemoved();
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<String> _resolvePhotoUrl() async {
    if (widget.photoUrl != null) {
      return await Modular.get<FirebaseStorage>()
          .refFromURL(widget.photoUrl!)
          .getDownloadURL();
    } else {
      return EndPoints.avatarsPublicProvider;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _resolvePhotoUrl(),
      builder: (context, snapshot) {
        final String photoUrl =
            snapshot.data ?? EndPoints.avatarsPublicProvider;

        return Padding(
          padding: const EdgeInsets.all(50.0).copyWith(bottom: 30),
          child: Center(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Profile Picture
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [context.cs.primary, context.cs.primaryContainer],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child:
                      _selectedImage == null &&
                          (snapshot.connectionState ==
                                  ConnectionState.waiting ||
                              snapshot.connectionState ==
                                  ConnectionState.active)
                      ? Center(
                          child: LoadingAnimationWidget.inkDrop(
                            color: context.cs.onPrimary,
                            size: 36,
                          ),
                        )
                      : _buildProfileImage(photoUrl: photoUrl),
                ),
                // Edit Icon Overlay
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _showImageSourceDialog,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: context.cs.primary,
                        border: Border.all(color: context.cs.surface, width: 3),
                      ),
                      child: Icon(
                        Icons.edit,
                        size: 18,
                        color: context.cs.onPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileImage({required String photoUrl}) {
    // Show selected image if available
    if (_selectedImage != null) {
      return ClipOval(
        child: Image.file(
          _selectedImage!,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildPlaceholder(),
        ),
      );
    }

    // Show network image if available

    return ClipOval(
      child: Image.network(
        photoUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildPlaceholder(),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Text(
        widget.initials,
        style: context.tt.headlineMedium?.copyWith(
          color: context.cs.onPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
