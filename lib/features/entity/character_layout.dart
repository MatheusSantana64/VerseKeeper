import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/models/character.dart';
import '../../core/models/entity_type.dart';
import 'entity_image_providers.dart';
import 'entity_library_providers.dart';

/// Aspect ratio (width / height) assumed when no photo can be measured.
const double defaultAspect = 4 / 3;

/// The three character card layouts available in the list screen.
enum CharacterLayoutType {
  /// Small photo on the left, name/age/profession and description on the
  /// right (the original list card).
  compact,

  /// Taller photo on the left, with name, age and profession stacked on the
  /// right.
  portrait,

  /// Big photo with the name below it.
  gallery,
}

extension CharacterLayoutTypeLabel on CharacterLayoutType {
  String get label => switch (this) {
        CharacterLayoutType.compact => 'Compact',
        CharacterLayoutType.portrait => 'Portrait',
        CharacterLayoutType.gallery => 'Gallery',
      };

  String get description => switch (this) {
        CharacterLayoutType.compact => 'Small photo with name, age, profession and description',
        CharacterLayoutType.portrait => 'Taller photo with name, age and profession',
        CharacterLayoutType.gallery => 'Big photo with the name below',
      };
}

/// Settings for one card layout. Each layout remembers its own values.
class CharacterLayoutSettings {
  const CharacterLayoutSettings({
    this.cardWidth = 380,
    this.cardHeight = 120,
    this.fontSize = 14,
    this.imageWidth = 140,
    this.imageHeight = 108,
    this.wholeImage = true,
    this.lockAspect = false,
  });

  /// Card width in logical pixels.
  final int cardWidth;

  /// Card height in logical pixels.
  final int cardHeight;

  /// Base text size for card content.
  final int fontSize;

  /// Desired photo width in logical pixels.
  final int imageWidth;

  /// Desired photo height in logical pixels.
  final int imageHeight;

  /// When true the photo is always shown whole (scaled to fit the card,
  /// never cropped); when false it fills the photo box and may be cropped.
  final bool wholeImage;

  /// When true the image width and height stay locked to the reference
  /// photo's proportions: moving one slider adjusts the other.
  final bool lockAspect;

  /// Whether the photo is rendered whole (never cropped): either via the
  /// whole-image toggle or because the size is locked to the photo.
  bool get showWholeImage => wholeImage || lockAspect;

  CharacterLayoutSettings copyWith({
    int? cardWidth,
    int? cardHeight,
    int? fontSize,
    int? imageWidth,
    int? imageHeight,
    bool? wholeImage,
    bool? lockAspect,
  }) {
    return CharacterLayoutSettings(
      cardWidth: cardWidth ?? this.cardWidth,
      cardHeight: cardHeight ?? this.cardHeight,
      fontSize: fontSize ?? this.fontSize,
      imageWidth: imageWidth ?? this.imageWidth,
      imageHeight: imageHeight ?? this.imageHeight,
      wholeImage: wholeImage ?? this.wholeImage,
      lockAspect: lockAspect ?? this.lockAspect,
    );
  }
}

/// Rendered sizes for one card given its layout settings: the size the card
/// box should be drawn at plus the photo box inside it.
class CharacterCardMetrics {
  const CharacterCardMetrics({
    required this.cardWidth,
    required this.cardHeight,
    required this.photoWidth,
    required this.photoHeight,
  });

  final double cardWidth;
  final double cardHeight;
  final double photoWidth;
  final double photoHeight;
}

/// Computes the rendered card and photo box sizes for [type] from [s].
///
/// When the photo is shown whole and its box does not fit inside the chosen
/// card size, the card grows so the whole image still fits — but never wider
/// than [maxWidth] (the available list width, since a `Wrap` clamps children
/// to it); when clamped, the photo box shrinks instead of overflowing.
/// Otherwise the card keeps its exact size and the photo box is clamped
/// (uniformly scaled) to the space the card has left.
CharacterCardMetrics characterCardMetrics(
  CharacterLayoutSettings s,
  CharacterLayoutType type, {
  double? maxWidth,
}) {
  const gap = 8.0;
  const cardPadding = 12.0;
  const textMin = 120.0;
  const galleryStrip = 32.0;

  final imageW = s.imageWidth.toDouble();
  final imageH = s.imageHeight.toDouble();
  final showWhole = s.showWholeImage;

  switch (type) {
    case CharacterLayoutType.compact:
    case CharacterLayoutType.portrait:
      if (showWhole) {
        final idealW = imageW + gap + textMin + cardPadding;
        final renderW = maxWidth == null
            ? math.max(s.cardWidth.toDouble(), idealW)
            : math.max(
                s.cardWidth.toDouble(),
                math.min(idealW, maxWidth),
              );
        final innerW = renderW - cardPadding;
        final photoW = math.min(
          imageW,
          math.max(0.0, innerW - gap - textMin),
        );
        return CharacterCardMetrics(
          cardWidth: renderW,
          cardHeight: math.max(s.cardHeight.toDouble(), imageH + cardPadding),
          photoWidth: photoW,
          photoHeight: imageH,
        );
      }
      final innerW = s.cardWidth - cardPadding;
      final innerH = s.cardHeight - cardPadding;
      final availableW = math.max(40.0, innerW - gap - textMin);
      final scale = (imageW <= 0 || imageH <= 0)
          ? 1.0
          : math.min(1.0, math.min(availableW / imageW, innerH / imageH));
      return CharacterCardMetrics(
        cardWidth: s.cardWidth.toDouble(),
        cardHeight: s.cardHeight.toDouble(),
        photoWidth: imageW * scale,
        photoHeight: imageH * scale,
      );
    case CharacterLayoutType.gallery:
      if (showWhole) {
        final idealW = math.max(s.cardWidth.toDouble(), imageW);
        final renderW = maxWidth == null ? idealW : math.min(idealW, maxWidth);
        return CharacterCardMetrics(
          cardWidth: renderW,
          cardHeight: math.max(
            s.cardHeight.toDouble(),
            imageH + galleryStrip,
          ),
          photoWidth: renderW - cardPadding,
          photoHeight: imageH,
        );
      }
      return CharacterCardMetrics(
        cardWidth: s.cardWidth.toDouble(),
        cardHeight: s.cardHeight.toDouble(),
        photoWidth: s.cardWidth.toDouble(),
        photoHeight: math.max(40.0, s.cardHeight - galleryStrip),
      );
  }
}

/// User preference for how character cards are laid out in the list: the
/// selected [type] plus independent settings for every layout.
class CharacterLayout {
  const CharacterLayout({
    this.type = CharacterLayoutType.compact,
    Map<CharacterLayoutType, CharacterLayoutSettings>? settings,
  }) : settings = settings ?? defaultSettings;

  final CharacterLayoutType type;
  final Map<CharacterLayoutType, CharacterLayoutSettings> settings;

  /// Settings for the currently selected [type].
  CharacterLayoutSettings get current => settings[type]!;

  CharacterLayout copyWith({
    CharacterLayoutType? type,
    Map<CharacterLayoutType, CharacterLayoutSettings>? settings,
  }) {
    return CharacterLayout(
      type: type ?? this.type,
      settings: settings ?? this.settings,
    );
  }

  static const defaultSettings = <CharacterLayoutType, CharacterLayoutSettings>{
    CharacterLayoutType.compact: CharacterLayoutSettings(),
    CharacterLayoutType.portrait: CharacterLayoutSettings(
      cardHeight: 160,
      imageWidth: 150,
      imageHeight: 148,
    ),
    CharacterLayoutType.gallery: CharacterLayoutSettings(
      cardHeight: 220,
      imageWidth: 380,
      imageHeight: 188,
      wholeImage: false,
    ),
  };
}

final sharedPreferencesProvider = FutureProvider<SharedPreferences>(
  (ref) => SharedPreferences.getInstance(),
);

/// Width/height ratio of the first character cover photo in the library.
/// Used by the aspect lock so a card can be sized to match a photo's shape.
/// Returns null when no photo can be measured (callers fall back to
/// [defaultAspect]); real file decoding never completes under widget-test
/// fake async, so tests should override this provider to stay deterministic.
final layoutImageAspectProvider = FutureProvider<double?>((ref) async {
  final characters =
      await ref.watch(entityListProvider(EntityType.character).future);
  final store = ref.watch(imageStoreProvider);
  for (final entity in characters) {
    if (entity is! Character) continue;
    final imageId = entity.coverImageId;
    if (imageId == null) continue;
    final path = await store.pathFor(imageId);
    if (path == null) continue;
    final bytes = await File(path).readAsBytes();
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    final width = frame.image.width;
    final height = frame.image.height;
    if (height == 0) continue;
    return width / height;
  }
  return null;
});

class CharacterLayoutNotifier extends Notifier<CharacterLayout> {
  @override
  CharacterLayout build() {
    final prefs = ref.watch(sharedPreferencesProvider).value;
    if (prefs == null) return const CharacterLayout();
    final type = CharacterLayoutType.values.firstWhere(
      (t) => t.name == prefs.getString('charLayoutType'),
      orElse: () => CharacterLayoutType.compact,
    );
    final settings = <CharacterLayoutType, CharacterLayoutSettings>{};
    for (final t in CharacterLayoutType.values) {
      final defaults = CharacterLayout.defaultSettings[t]!;
      settings[t] = CharacterLayoutSettings(
        cardWidth: (prefs.getInt('charW_${t.name}') ?? defaults.cardWidth)
            .clamp(160, 800),
        cardHeight: (prefs.getInt('charH_${t.name}') ?? defaults.cardHeight)
            .clamp(90, 360),
        fontSize: (prefs.getInt('charFont_${t.name}') ?? defaults.fontSize)
            .clamp(10, 22),
        imageWidth:
            (prefs.getInt('charImgW_${t.name}') ?? defaults.imageWidth)
                .clamp(40, 800),
        imageHeight:
            (prefs.getInt('charImgH_${t.name}') ?? defaults.imageHeight)
                .clamp(40, 800),
        wholeImage:
            prefs.getBool('charWhole_${t.name}') ?? defaults.wholeImage,
        lockAspect:
            prefs.getBool('charLock_${t.name}') ?? defaults.lockAspect,
      );
    }
    return CharacterLayout(type: type, settings: settings);
  }

  Future<void> setLayout(CharacterLayout layout) async {
    state = layout;
    try {
      final prefs = await ref.read(sharedPreferencesProvider.future);
      await prefs.setString('charLayoutType', layout.type.name);
      for (final entry in layout.settings.entries) {
        final name = entry.key.name;
        final s = entry.value;
        await prefs.setInt('charW_$name', s.cardWidth);
        await prefs.setInt('charH_$name', s.cardHeight);
        await prefs.setInt('charFont_$name', s.fontSize);
        await prefs.setInt('charImgW_$name', s.imageWidth);
        await prefs.setInt('charImgH_$name', s.imageHeight);
        await prefs.setBool('charWhole_$name', s.wholeImage);
        await prefs.setBool('charLock_$name', s.lockAspect);
      }
    } catch (_) {
      // Persistence unavailable (e.g. widget tests): keep the in-memory value.
    }
  }
}

final characterLayoutProvider =
    NotifierProvider<CharacterLayoutNotifier, CharacterLayout>(
  CharacterLayoutNotifier.new,
);

/// Opens the dialog that lets the user pick a card layout plus per-layout
/// card size, font size, image size and whole-image behavior.
Future<void> showCharacterLayoutDialog(BuildContext context, WidgetRef ref) {
  final current = ref.read(characterLayoutProvider);
  var pendingType = current.type;
  final pending =
      Map<CharacterLayoutType, CharacterLayoutSettings>.from(current.settings);

  return showDialog<void>(
    context: context,
    builder: (context) => Consumer(
      builder: (context, ref, _) {
        final aspect =
            ref.watch(layoutImageAspectProvider).value ?? defaultAspect;
        return StatefulBuilder(
          builder: (context, setState) {
            final s = pending[pendingType]!;
            return AlertDialog(
              title: const Text('Character layout'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Layout',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    RadioGroup<CharacterLayoutType>(
                      groupValue: pendingType,
                      onChanged: (value) {
                        if (value != null) setState(() => pendingType = value);
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (final type in CharacterLayoutType.values)
                            RadioListTile<CharacterLayoutType>(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              title: Text(type.label),
                              subtitle: Text(type.description),
                              value: type,
                            ),
                        ],
                      ),
                    ),
                    const Divider(height: 24),
                    Text(
                      'Card',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    _layoutSlider(
                      context,
                      setState,
                      key: const ValueKey('cardWidthSlider'),
                      label: 'Card width',
                      value: s.cardWidth,
                      min: 160,
                      max: 800,
                      step: 20,
                      unit: 'px',
                      onChanged: (v) => setState(() {
                        pending[pendingType] =
                            pending[pendingType]!.copyWith(cardWidth: v);
                      }),
                    ),
                    _layoutSlider(
                      context,
                      setState,
                      key: const ValueKey('cardHeightSlider'),
                      label: 'Card height',
                      value: s.cardHeight,
                      min: 90,
                      max: 360,
                      step: 15,
                      unit: 'px',
                      onChanged: (v) => setState(() {
                        pending[pendingType] =
                            pending[pendingType]!.copyWith(cardHeight: v);
                      }),
                    ),
                    _layoutSlider(
                      context,
                      setState,
                      key: const ValueKey('fontSizeSlider'),
                      label: 'Font size',
                      value: s.fontSize,
                      min: 10,
                      max: 22,
                      step: 1,
                      unit: 'pt',
                      onChanged: (v) => setState(() {
                        pending[pendingType] =
                            pending[pendingType]!.copyWith(fontSize: v);
                      }),
                    ),
                    const Divider(height: 24),
                    Text(
                      'Image',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    _layoutSlider(
                      context,
                      setState,
                      key: const ValueKey('imageWidthSlider'),
                      label: 'Image width',
                      value: s.imageWidth,
                      min: 40,
                      max: 800,
                      step: 10,
                      unit: 'px',
                      onChanged: (v) => setState(() {
                        var next =
                            pending[pendingType]!.copyWith(imageWidth: v);
                        if (next.lockAspect) {
                          next = next.copyWith(
                            imageHeight:
                                (v / aspect).round().clamp(40, 800),
                          );
                        }
                        pending[pendingType] = next;
                      }),
                    ),
                    _layoutSlider(
                      context,
                      setState,
                      key: const ValueKey('imageHeightSlider'),
                      label: 'Image height',
                      value: s.imageHeight,
                      min: 40,
                      max: 800,
                      step: 10,
                      unit: 'px',
                      onChanged: (v) => setState(() {
                        var next =
                            pending[pendingType]!.copyWith(imageHeight: v);
                        if (next.lockAspect) {
                          next = next.copyWith(
                            imageWidth:
                                (v * aspect).round().clamp(40, 800),
                          );
                        }
                        pending[pendingType] = next;
                      }),
                    ),
                    const Divider(height: 24),
                    CheckboxListTile(
                      key: const ValueKey('wholeImageCheckbox'),
                      value: s.wholeImage,
                      onChanged: (v) => setState(() {
                        pending[pendingType] = pending[pendingType]!
                            .copyWith(wholeImage: v ?? false);
                      }),
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: const Text('Always show the whole image'),
                      subtitle: const Text(
                        'Oversized photos grow the card so nothing is cropped',
                      ),
                    ),
                    CheckboxListTile(
                      key: const ValueKey('aspectLockCheckbox'),
                      value: s.lockAspect,
                      onChanged: (v) => setState(() {
                        pending[pendingType] = pending[pendingType]!.copyWith(
                          lockAspect: v ?? false,
                          wholeImage: (v ?? false)
                              ? true
                              : pending[pendingType]!.wholeImage,
                        );
                      }),
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: const Text("Lock size to the photo's proportions"),
                      subtitle: const Text(
                        'Changing image width or height keeps the exact photo proportions',
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    ref.read(characterLayoutProvider.notifier).setLayout(
                          CharacterLayout(
                              type: pendingType, settings: pending),
                        );
                    Navigator.of(context).pop();
                  },
                  child: const Text('Apply'),
                ),
              ],
            );
          },
        );
      },
    ),
  );
}

Widget _layoutSlider(
  BuildContext context,
  StateSetter setState, {
  required Key key,
  required String label,
  required int value,
  required int min,
  required int max,
  required int step,
  required String unit,
  required ValueChanged<int> onChanged,
}) {
  final divisions = ((max - min) / step).round();
  return Row(
    children: [
      Expanded(
        child: Text('$label: $value$unit'),
      ),
      SizedBox(
        width: 200,
        child: Slider(
          key: key,
          value: value.toDouble(),
          min: min.toDouble(),
          max: max.toDouble(),
          divisions: divisions,
          label: '$value$unit',
          onChanged: (v) {
            final rounded = v.round();
            setState(() => onChanged(rounded));
          },
        ),
      ),
    ],
  );
}
