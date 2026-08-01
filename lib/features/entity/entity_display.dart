import '../../core/models/stored_entity.dart';

/// Best display name for any stored entity, regardless of concrete type.
String displayNameOf(StoredEntity entity) {
  final json = entity.toJson();
  final name = json['name'];
  final title = json['title'];
  if (name is String && name.trim().isNotEmpty) return name;
  if (title is String && title.trim().isNotEmpty) return title;
  return entity.id;
}

/// Short plaintext preview for list tiles, from the first non-empty long-form
/// field the entity has.
String? previewOf(StoredEntity entity) {
  final json = entity.toJson();
  for (final key in const [
    'notes',
    'summary',
    'personality',
    'appearance',
    'description',
    'speechStyle',
  ]) {
    final value = json[key];
    if (value is String && value.trim().isNotEmpty) {
      final text = value.trim();
      return text.length > 160 ? '${text.substring(0, 157)}...' : text;
    }
  }
  return null;
}

/// "coverImageId" -> "Cover image id".
String prettyLabel(String key) {
  final spaced = key.replaceAllMapped(
    RegExp(r'([a-z0-9])([A-Z])'),
    (match) => '${match[1]} ${match[2]}',
  );
  return spaced.isEmpty ? spaced : spaced[0].toUpperCase() + spaced.substring(1);
}

/// Renders any JSON value for display, flattening nested maps/lists.
String formatValue(Object? value) {
  if (value == null) return '';
  if (value is String) return _formatString(value);
  if (value is num || value is bool) return value.toString();
  if (value is Map) {
    final entries =
        value.entries.where((entry) => formatValue(entry.value).isNotEmpty);
    return entries
        .map((entry) => '${prettyLabel(entry.key)}: ${formatValue(entry.value)}')
        .join('\n');
  }
  if (value is List) {
    if (value.isEmpty) return '';
    return value.map(formatValue).join('\n');
  }
  return value.toString();
}

String _formatString(String value) {
  final trimmed = value.trim();
  if (RegExp(r'^\d{4}-\d{2}-\d{2}').hasMatch(trimmed)) {
    final parsed = DateTime.tryParse(trimmed);
    if (parsed != null) {
      final local = parsed.toLocal();
      final date = '${local.year}-'
          '${local.month.toString().padLeft(2, '0')}-'
          '${local.day.toString().padLeft(2, '0')}';
      final time = '${local.hour.toString().padLeft(2, '0')}:'
          '${local.minute.toString().padLeft(2, '0')}';
      return '$date $time';
    }
  }
  return trimmed;
}
