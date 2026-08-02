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
    this.columns = 1,
  });

  final CharacterLayoutType type;

  /// How many cards fit in one row, from 1 up to 5.
  final int columns;

  CharacterLayout copyWith({CharacterLayoutType? type, int? columns}) {
    return CharacterLayout(
      type: type ?? this.type,
      columns: columns ?? this.columns,
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
      columns: (prefs.getInt('charLayoutColumns') ?? 1).clamp(1, 5),
    );
  }

  Future<void> setLayout(CharacterLayout layout) async {
    state = layout;
    try {
      final prefs = await ref.read(sharedPreferencesProvider.future);
      await prefs.setString('charLayoutType', layout.type.name);
      await prefs.setInt('charLayoutColumns', layout.columns);
    } catch (_) {
      // Persistence unavailable (e.g. widget tests): keep the in-memory value.
    }
  }
}

final characterLayoutProvider =
    NotifierProvider<CharacterLayoutNotifier, CharacterLayout>(
  CharacterLayoutNotifier.new,
);

/// Opens the dialog that lets the user pick a card layout and cards-per-line.
Future<void> showCharacterLayoutDialog(BuildContext context, WidgetRef ref) {
  final current = ref.read(characterLayoutProvider);
  var pendingType = current.type;
  var pendingColumns = current.columns;

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
              Row(
                children: [
                  Expanded(
                    child: Text('Cards per line: $pendingColumns'),
                  ),
                  SizedBox(
                    width: 200,
                    child: Slider(
                      value: pendingColumns.toDouble(),
                      min: 1,
                      max: 5,
                      divisions: 4,
                      label: '$pendingColumns',
                      onChanged: (value) =>
                          setState(() => pendingColumns = value.round()),
                    ),
                  ),
                ],
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
                      columns: pendingColumns,
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
