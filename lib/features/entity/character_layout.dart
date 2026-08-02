import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    this.wholeImage = true,
  });

  /// Card width in logical pixels.
  final int cardWidth;

  /// Card height in logical pixels.
  final int cardHeight;

  /// Base text size for card content.
  final int fontSize;

  /// When true the photo is always shown whole (scaled to fit the card,
  /// never cropped); when false it fills the photo box and may be cropped.
  final bool wholeImage;

  CharacterLayoutSettings copyWith({
    int? cardWidth,
    int? cardHeight,
    int? fontSize,
    bool? wholeImage,
  }) {
    return CharacterLayoutSettings(
      cardWidth: cardWidth ?? this.cardWidth,
      cardHeight: cardHeight ?? this.cardHeight,
      fontSize: fontSize ?? this.fontSize,
      wholeImage: wholeImage ?? this.wholeImage,
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
    CharacterLayoutType.gallery: CharacterLayoutSettings(
      cardHeight: 220,
      wholeImage: false,
    ),
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
        wholeImage:
            prefs.getBool('charWhole_${t.name}') ?? defaults.wholeImage,
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
        await prefs.setBool('charWhole_$name', s.wholeImage);
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
/// card size, font size and whole-image behavior.
Future<void> showCharacterLayoutDialog(BuildContext context, WidgetRef ref) {
  final current = ref.read(characterLayoutProvider);
  var pendingType = current.type;
  final pending =
      Map<CharacterLayoutType, CharacterLayoutSettings>.from(current.settings);

  return showDialog<void>(
    context: context,
    builder: (context) => StatefulBuilder(
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
                CheckboxListTile(
                  key: const ValueKey('wholeImageCheckbox'),
                  value: s.wholeImage,
                  onChanged: (v) => setState(() {
                    pending[pendingType] =
                        pending[pendingType]!.copyWith(wholeImage: v ?? false);
                  }),
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: const Text('Always show the whole image'),
                  subtitle: const Text(
                    'Scale the photo to fit the card instead of cropping it',
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
                      CharacterLayout(type: pendingType, settings: pending),
                    );
                Navigator.of(context).pop();
              },
              child: const Text('Apply'),
            ),
          ],
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
