import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/images/cover_image_picker.dart';
import '../../core/images/image_store.dart';

/// Local image store for entity photos.
final imageStoreProvider = Provider<ImageStore>((ref) => ImageStore());

/// Platform image picker for the "main photo" field.
final coverImagePickerProvider =
    Provider<CoverImagePicker>((ref) => const GalleryCoverImagePicker());

/// Renders a stored cover image, falling back to a placeholder when none is
/// set or the backing file is missing (e.g. in tests without real files).
///
/// Defaults to a fixed [size] square (image cropped to fill it). Pass
/// [fixedHeight] instead to show the whole photo: the width then follows the
/// image's aspect ratio and nothing is cropped.
class CoverImage extends ConsumerWidget {
  const CoverImage({
    super.key,
    required this.imageId,
    this.size = 56,
    this.fixedHeight,
    this.borderRadius = 8,
    this.icon = Icons.person_outline,
  });

  final String? imageId;
  final double size;
  final double? fixedHeight;
  final double borderRadius;
  final IconData icon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final height = fixedHeight ?? size;

    Widget placeholder() => Container(
          width: fixedHeight == null ? size : height * 1.5,
          height: height,
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Icon(icon, size: height * 0.5, color: theme.colorScheme.onPrimaryContainer),
        );
    if (imageId == null) return placeholder();
    final store = ref.watch(imageStoreProvider);
    return FutureBuilder<String?>(
      future: store.pathFor(imageId!),
      builder: (context, snapshot) {
        final path = snapshot.data;
        if (path == null) return placeholder();
        return ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Image.file(
            File(path),
            width: fixedHeight == null ? size : null,
            height: height,
            fit: fixedHeight == null ? BoxFit.cover : BoxFit.contain,
            errorBuilder: (_, _, _) => placeholder(),
          ),
        );
      },
    );
  }
}
