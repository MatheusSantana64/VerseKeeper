import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

/// Persists character cover images on disk, keyed by a plain file name that
/// is stored on the character's `coverImageId`.
///
/// A local store is the source of truth until sync lands; the sync engine will
/// upload these bytes to Storage (mirroring the boundary-encryption design).
class ImageStore {
  ImageStore({this.overrideDirectory});

  /// Optional directory to use instead of the platform documents folder.
  /// Tests inject a temp directory here.
  final Directory? overrideDirectory;

  Future<Directory> _imagesDirectory() async {
    final override = overrideDirectory;
    if (override != null) {
      await override.create(recursive: true);
      return override;
    }
    final base = await getApplicationDocumentsDirectory();
    final dir = Directory('${base.path}${Platform.pathSeparator}images');
    await dir.create(recursive: true);
    return dir;
  }

  /// Persists [bytes] as `$id.png` and returns the stored file name.
  Future<String> saveImage(String id, Uint8List bytes) async {
    final dir = await _imagesDirectory();
    final fileName = '$id.png';
    await File('${dir.path}${Platform.pathSeparator}$fileName')
        .writeAsBytes(bytes);
    return fileName;
  }

  /// Absolute path for a stored file name, or `null` if the file is missing.
  Future<String?> pathFor(String fileName) async {
    final dir = await _imagesDirectory();
    final file = File('${dir.path}${Platform.pathSeparator}$fileName');
    if (!file.existsSync()) return null;
    return file.path;
  }

  /// Deletes a stored file, if present.
  Future<void> deleteImage(String fileName) async {
    final dir = await _imagesDirectory();
    final file = File('${dir.path}${Platform.pathSeparator}$fileName');
    if (await file.exists()) {
      await file.delete();
    }
  }
}
