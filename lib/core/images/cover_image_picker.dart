import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

/// Picks an image from the device gallery and returns its bytes, or `null` if
/// the user cancelled. Wrapped behind an interface so widget tests can fake
/// picking without touching platform channels.
abstract interface class CoverImagePicker {
  Future<Uint8List?> pick();
}

/// Default implementation backed by the platform image picker.
class GalleryCoverImagePicker implements CoverImagePicker {
  const GalleryCoverImagePicker();

  @override
  Future<Uint8List?> pick() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
      maxHeight: 1200,
      imageQuality: 85,
    );
    return picked?.readAsBytes();
  }
}
