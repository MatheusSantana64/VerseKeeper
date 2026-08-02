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

/// User preference for how character cards are laid out in the list.
class CharacterLayout {
  const CharacterLayout({
    this.type = CharacterLayoutType.compact,
    this.cardWidth = 380,
    this.cardHeight = 120,
    this.fontSize = 14,
  });

  final CharacterLayoutType type;

  /// Card width in logical pixels.
  final int cardWidth;

  /// Card height in logical pixels.
  final int cardHeight;

  /// Base text size for card content.
  final int fontSize;

  CharacterLayout copyWith({
    CharacterLayoutType? type,
    int? cardWidth,
    int? cardHeight,
    int? fontSize,
  }) {
    return CharacterLayout(
      type: type ?? this.type,
      cardWidth: cardWidth ?? this.cardWidth,
      cardHeight: cardHeight ?? this.cardHeight,
      fontSize: fontSize ?? this.fontSize,
    );
  }
}

final sharedPreferencesProvider = FutureProvider<SharedPreferences>(
  (ref) => SharedPreferences.getInstance(),
);

class CharacterLayoutNotifier extends Notifier<CharacterLayout> {
  @override
  CharacterLayout build() {
    final prefs = ref.watch(sharedPreferencesProvider).value;
    if (prefs == null) return const CharacterLayout();
    return CharacterLayout(
      type: CharacterLayoutType.values.firstWhere(
        (t) => t.name == prefs.getString('charLayoutType'),
        orElse: () => CharacterLayoutType.compact,
      ),
      cardWidth: (prefs.getInt('charCardWidth') ?? 380).clamp(160, 800),
      cardHeight: (prefs.getInt('charCardHeight') ?? 120).clamp(90, 360),
      fontSize: (prefs.getInt('charFontSize') ?? 14).clamp(10, 22),
    );
  }

  Future<void> setLayout(CharacterLayout layout) async {
    state = layout;
    try {
      final prefs = await ref.read(sharedPreferencesProvider.future);
      await prefs.setString('charLayoutType', layout.type.name);
      await prefs.setInt('charCardWidth', layout.cardWidth);
      await prefs.setInt('charCardHeight', layout.cardHeight);
      await prefs.setInt('charFontSize', layout.fontSize);
    } catch (_) {
      // Persistence unavailable (e.g. widget tests): keep the in-memory value.
    }
  }
}

final characterLayoutProvider =
    NotifierProvider<CharacterLayoutNotifier, CharacterLayout>(
  CharacterLayoutNotifier.new,
);

/// Opens the dialog that lets the user pick a card layout, card size and font
/// size.
Future<void> showCharacterLayoutDialog(BuildContext context, WidgetRef ref) {
  final current = ref.read(characterLayoutProvider);
  var pendingType = current.type;
  var pendingWidth = current.cardWidth;
  var pendingHeight = current.cardHeight;
  var pendingFontSize = current.fontSize;

  return showDialog<void>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
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
                value: pendingWidth,
                min: 160,
                max: 800,
                step: 20,
                unit: 'px',
                onChanged: (v) => pendingWidth = v,
              ),
              _layoutSlider(
                context,
                setState,
                key: const ValueKey('cardHeightSlider'),
                label: 'Card height',
                value: pendingHeight,
                min: 90,
                max: 360,
                step: 15,
                unit: 'px',
                onChanged: (v) => pendingHeight = v,
              ),
              _layoutSlider(
                context,
                setState,
                key: const ValueKey('fontSizeSlider'),
                label: 'Font size',
                value: pendingFontSize,
                min: 10,
                max: 22,
                step: 1,
                unit: 'pt',
                onChanged: (v) => pendingFontSize = v,
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
                      type: pendingType,
                      cardWidth: pendingWidth,
                      cardHeight: pendingHeight,
                      fontSize: pendingFontSize,
                    ),
                  );
              Navigator.of(context).pop();
            },
            child: const Text('Apply'),
          ),
        ],
      ),
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
