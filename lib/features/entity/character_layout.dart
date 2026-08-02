import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The three character card layouts available in the list screen.
enum CharacterLayoutType {
  /// Small photo on the left, name/age/profession and description on the
  /// right (the original list card).
  compact,

  /// Taller photo on the left, with name, age, profession and description
  /// stacked on the right.
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
        CharacterLayoutType.compact =>
          'Small photo with name, age, profession and description',
        CharacterLayoutType.portrait =>
          'Taller photo with name, age, profession and description',
        CharacterLayoutType.gallery => 'Big photo with the name below',
      };
}

/// Settings for one card layout. Each layout remembers its own values.
class CharacterLayoutSettings {
  const CharacterLayoutSettings({
    this.cardWidth = 380,
    this.cardHeight = 120,
    this.fontSize = 14,
  });

  /// Card width in logical pixels.
  final int cardWidth;

  /// Card height in logical pixels.
  final int cardHeight;

  /// Base text size for card content.
  final int fontSize;

  CharacterLayoutSettings copyWith({
    int? cardWidth,
    int? cardHeight,
    int? fontSize,
  }) {
    return CharacterLayoutSettings(
      cardWidth: cardWidth ?? this.cardWidth,
      cardHeight: cardHeight ?? this.cardHeight,
      fontSize: fontSize ?? this.fontSize,
    );
  }
}

/// Rendered sizes for one card: the size the card box is drawn at plus the
/// photo box inside it. The photo box is always derived from the card (the
/// photo takes a fixed share of the card's width, its height follows the
/// card's height) so the image always fits fully and is never larger than
/// the card.
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

const double _cardPadding = 12.0;
const double _galleryStrip = 32.0;

/// Photo box height in the side-by-side layouts. The photo is pinned to the
/// card's height; its width follows the image's aspect ratio (via
/// `CoverImage.fixedHeight`), so the text always starts exactly at the image's
/// right edge instead of after a fixed wide box.
double _sidePhotoSide(double cardH) => math.max(40.0, cardH);

/// Computes the rendered card and photo box sizes for [type] from [s].
///
/// The photo box derives from the card: in compact/portrait the photo is
/// height-driven (a square in [characterCardMetrics] terms; the rendered
/// `CoverImage.fixedHeight` box is width-aspect-following), in gallery it
/// takes the full card width minus a name strip. Images are drawn contained
/// inside this box (`BoxFit.contain`, top-left aligned), so they are always
/// fully visible.
CharacterCardMetrics characterCardMetrics(
  CharacterLayoutSettings s,
  CharacterLayoutType type,
) {
  final cardW = s.cardWidth.toDouble();
  final cardH = s.cardHeight.toDouble();
  switch (type) {
    case CharacterLayoutType.compact:
      final side = _sidePhotoSide(cardH);
      return CharacterCardMetrics(
        cardWidth: cardW,
        cardHeight: cardH,
        photoWidth: side,
        photoHeight: side,
      );
    case CharacterLayoutType.portrait:
      final side = _sidePhotoSide(cardH);
      return CharacterCardMetrics(
        cardWidth: cardW,
        cardHeight: cardH,
        photoWidth: side,
        photoHeight: side,
      );
    case CharacterLayoutType.gallery:
      return CharacterCardMetrics(
        cardWidth: cardW,
        cardHeight: cardH,
        photoWidth: math.max(40.0, cardW - _cardPadding),
        photoHeight: math.max(40.0, cardH - _galleryStrip),
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
    CharacterLayoutType.portrait: CharacterLayoutSettings(cardHeight: 160),
    CharacterLayoutType.gallery: CharacterLayoutSettings(cardHeight: 220),
  };
}

final sharedPreferencesProvider = FutureProvider<SharedPreferences>(
  (ref) => SharedPreferences.getInstance(),
);

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
/// card width, height and font size.
Future<void> showCharacterLayoutDialog(BuildContext context, WidgetRef ref) {
  final current = ref.read(characterLayoutProvider);
  var pendingType = current.type;
  final pending =
      Map<CharacterLayoutType, CharacterLayoutSettings>.from(current.settings);

  return showDialog<void>(
    context: context,
    builder: (context) => Consumer(
      builder: (context, ref, _) {
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
  return Row(
    children: [
      Expanded(
        child: Text('$label: $value$unit'),
      ),
      SizedBox(
        width: 200,
        child: _SteppedSlider(
          key: key,
          value: value.toDouble(),
          min: min.toDouble(),
          max: max.toDouble(),
          step: step.toDouble(),
          onChanged: (v) => setState(() => onChanged(v.round())),
        ),
      ),
    ],
  );
}

/// Draggable, stepped slider without Material's `Slider` (which always wraps
/// its value indicator in an `OverlayPortal`; on Windows that serializes an
/// orphan semantics node inside a pushed route and floods the log with
/// `Failed to update ui::AXTree` — see flutter/flutter#190357). Pure visual
/// + gesture control, so it also keeps the semantics tree quiet during drags.
///
/// LayoutBuilder-free: `AlertDialog` queries intrinsic dimensions of its
/// content, which a `LayoutBuilder` cannot answer. Positioning uses
/// [Align]/[FractionallySizedBox] with fraction-relative alignment, so no
/// absolute width is needed.
class _SteppedSlider extends StatelessWidget {
  const _SteppedSlider({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.step,
    required this.onChanged,
  });

  final double value;
  final double min;
  final double max;
  final double step;
  final ValueChanged<double> onChanged;

  void _updateFromX(BuildContext context, double x) {
    final width = context.size?.width ?? 1.0;
    if (width <= 0) return;
    final ratio = (x / width).clamp(0.0, 1.0);
    final raw = min + ratio * (max - min);
    final stepped = ((raw / step).round() * step).clamp(min, max);
    onChanged(stepped);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = ((value - min) / (max - min)).clamp(0.0, 1.0);
    const thumbSize = 16.0;
    return SizedBox(
      width: double.infinity,
      height: 32,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (d) => _updateFromX(context, d.localPosition.dx),
        onHorizontalDragUpdate: (d) =>
            _updateFromX(context, d.localPosition.dx),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Container(
              height: 6,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: progress,
                heightFactor: 1,
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment(progress * 2 - 1, 0),
              child: Container(
                width: thumbSize,
                height: thumbSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.primary,
                  border: Border.all(
                    color: theme.colorScheme.onPrimary,
                    width: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
