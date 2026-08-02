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
/// image's aspect ratio and nothing is cropped. Pass [fill] to expand to the
/// available box (width and height are `double.infinity`); [fillFit] then
/// controls how the image is fit into that box (default crops to fill).
///
/// When a photo is set and [viewEnabled] is true, tapping the image opens a
/// fullscreen preview that supports pinch-to-zoom and panning.
class CoverImage extends ConsumerWidget {
  const CoverImage({
    super.key,
    required this.imageId,
    this.size = 56,
    this.fixedHeight,
    this.fill = false,
    this.fillFit = BoxFit.cover,
    this.borderRadius = 8,
    this.icon = Icons.person_outline,
    this.viewEnabled = true,
  });

  final String? imageId;
  final double size;
  final double? fixedHeight;
  final bool fill;
  final BoxFit fillFit;
  final double borderRadius;
  final IconData icon;
  final bool viewEnabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final height = fixedHeight ?? size;

    Widget placeholder() => Container(
          width: fill ? double.infinity : (fixedHeight == null ? size : height * 1.5),
          height: fill ? double.infinity : height,
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
        final Widget image = ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Image.file(
            File(path),
            width: fill ? double.infinity : (fixedHeight == null ? size : null),
            height: fill ? double.infinity : height,
            fit: fill ? fillFit : (fixedHeight == null ? BoxFit.cover : BoxFit.contain),
            errorBuilder: (_, _, _) => placeholder(),
          ),
        );
        if (!viewEnabled) return image;
        return GestureDetector(
          onTap: () => showCoverImagePreview(context, path),
          child: image,
        );
      },
    );
  }
}

/// Opens a fullscreen, pinch-to-zoom preview of the image at [path].
Future<void> showCoverImagePreview(BuildContext context, String path) {
  return showDialog<void>(
    context: context,
    builder: (context) => Dialog.fullscreen(
      backgroundColor: Colors.black,
      child: Stack(
        children: [
          Positioned.fill(
            child: InteractiveViewer(
              maxScale: 6,
              child: Center(
                child: Image.file(File(path), fit: BoxFit.contain),
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: SafeArea(
              child: IconButton(
                tooltip: 'Close',
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close, color: Colors.white, size: 28),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
