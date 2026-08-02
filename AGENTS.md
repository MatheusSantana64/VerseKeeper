# AGENTS.md

VerseKeeper is a Flutter app (Windows + Android targets) for worldbuilding with reusable characters. Clean architecture: `lib/core` (pure Dart: models, encryption, utils), `lib/data/local` (drift DB + DAOs), `lib/data/repositories` (feature-facing `EntityRepository<T>` interface + local impl), `lib/features` (Riverpod UI + go_router), `lib/shared` (theme). `lib/data/remote` + `lib/data/sync` are **planned but do not exist yet** — do not assume them. Planned stack: drift (local SQLite, exists), Firestore + Storage (sync backend), go_router (wired, see below).

## Repositories

- Features depend on typed `EntityRepository<T>` providers from `lib/data/repositories/repository_providers.dart` (`characterRepositoryProvider`, ...) and on `searchRepositoryProvider` — never on the drift DAO directly. The interface is sync-agnostic; the future sync engine will be wired behind it without changing feature code.
- Cross-entity FTS5 search is separate (`SearchRepository`) because it spans all entity types.

## UI (features + routing)

- `lib/features/router/app_router.dart` builds the go_router table (`goRouterProvider`): `/` dashboard, `/search`, `/graph` (relationship graph), `/library/:type`, `/library/:type/:id`. Screens use `AppDrawer` (`lib/features/app_shell/app_drawer.dart`) for navigation.
- Screens must not depend on `lib/data/local` (clean arch: features → repositories only). `lib/features/entity/entity_library_providers.dart` provides generic `StreamProvider.family`/`FutureProvider.family` bridges (`entityListProvider`, `entityCountProvider`, `entityDetailProvider`) that switch over the typed repo providers; `entity_type_config.dart` maps `EntityType` → label/icon; `entity_display.dart` derives display names/previews from `toJson()` (no codec dependency).
- New entity types need: a config entry in `entity_type_config.dart`, plus (if promoted in the drawer/dashboard) a slot in `primaryEntityTypes`.
- The relationship graph (`relationship_graph_screen.dart`, route `/graph`) renders all characters as a circle; edges are owned relationships plus derived inverses (see `RelationshipType.inverse`). Node taps navigate to the character detail.
- The character list has switchable card layouts (compact / portrait / gallery) and a cards-per-line setting (1–5), chosen via a dialog from the list app bar and persisted with `shared_preferences`; see `character_layout.dart` (`characterLayoutProvider`). Cards are laid out with a `Wrap` so rows size to content.

## Editing (Phase 5)

- Create/edit uses a spec-driven generic form. `lib/features/entity/entity_form_spec.dart` declares the editable fields per type (`FormFieldKind`: text/multiline/tags/number/entityPicker/entityPickerMulti/relationshipList/storyAppearanceList — list-valued refs like `Character.universeIds` must use `entityPickerMulti`, never `entityPicker`). `entity_edit_screen.dart` builds a model from form values + generated `id`/timestamps via `entityFromJson` in `entity_actions.dart` (JSON→model and save/delete switches over the typed repos — mirrors the `_watchAll` switch pattern). Nested editors implemented: character relationships (`relationshipList`) and story casting (`storyAppearanceList`, character + optional version + role). Characters have a main photo: `CoverImage`/picker/store live in `lib/core/images/` + `lib/features/entity/entity_image_providers.dart`; the edit form persists `coverImageId` (a plain file name), and the detail header, list tiles, and version snapshot render it via `CoverImage`. `CoverImage` defaults to a fixed square crop; pass `fixedHeight` to show the whole photo with width following the aspect ratio (the character list card does this). Tapping a photo opens a fullscreen pinch-to-zoom preview (`showCoverImagePreview`). Widget tests must override `imageStoreProvider` (real filesystem IO never completes under fake async — use the in-memory subclass pattern in `test/features/entity_cover_image_test.dart`) and `coverImagePickerProvider`.
- `fromJson` tolerates missing keys (json_serializable emits defaults), so create JSON only needs `id`/`createdAt`/`updatedAt` + the required name/title field + the edited values.
- Routes: `/library/:type/new` (create, declared before `:id` so `new` never matches an id) and `/library/:type/:id/edit`. Create forms accept a `?key=value` query string via `EntityEditScreen.initialValues` (e.g. `/library/characterVersion/new?characterId=...`) to pre-fill picks.
- Character detail manages versions (list + "New version" with the character pre-selected) and shows a resolved snapshot on the version detail via `Character.resolve`. `deleteEntity` for `fieldDefinition` also strips the definition's key from every character's `customFields` (`entity_actions.dart`).
- Widget tests that fill a long form: set `tester.view.physicalSize` to a tall viewport — `scrollUntilVisible` is unreliable here because every `TextField` contributes a `Scrollable` (multi-match).

## Local storage (drift document-store)

- One `entities` table holds every entity as a JSON blob (`data`) plus denormalized `name`, `type`, timestamps, and a `deleted` tombstone. Nested structures (relationships, story appearances, images) live inside the JSON — do not add per-entity or join tables.
- Each entity type has a codec in `lib/data/local/entity_codecs.dart` (registered in the `entityCodecs` map) that provides fromJson/name/searchText. New entity types need: enum value in `entity_type.dart`, a model implementing `StoredEntity`, a codec + registry entry.
- Search uses a raw-SQL FTS5 virtual table (`entity_search`, created in `MigrationStrategy.onCreate`; drift has no FTS5 DSL). DAO mutations must keep the FTS row in sync.
- Models implement `StoredEntity` (`id`, `createdAt`, `updatedAt`, `entityType`, `toJson`); each also declares `EntityType get entityType` and needs `const X._();` for freezed.
- **Nested models serialize as raw freezed objects, not maps.** `Character.toJson()` emits `List<Relationship>` (json_serializable does not recurse into freezed `toJson`). Detail renderers must handle both `Relationship`/`StoryAppearance` objects and `Map`s; the edit form normalizes to maps.
- The DAO exposes `watchAll` (stream), `getAll` (one-shot snapshot), `getById`, `count`, `search`/`watchSearch`. Prefer `getAll` over `watchAll().first` inside handlers — drift streams schedule `Timer.run`s that don't complete in widget-test fake-async zones.

## Commands

- `flutter analyze` — must be clean before finishing any task.
- `flutter test` — run the whole suite.
- `dart run build_runner build` — required after editing any model or provider. Do NOT pass `--delete-conflicting-outputs`; build_runner 2.15 removed the flag (it's just an ignored warning). Generated `*.freezed.dart` / `*.g.dart` files are **committed to the repo** — regenerate and include them in changes.
- `flutter build windows --debug` / `flutter build apk --debug` — target verification. Windows link noise (`LNK4099: PDB not found`) from Firebase C++ libs is benign.

## Model codegen gotchas

- All models are `@freezed` + `json_serializable` with `@Default(...)` list fields (never bare nullable-free fields without defaults).
- **json_serializable fails with `InvalidType` unless a nested model type is imported directly in the file that uses it.** Dart has no transitive imports: `character.dart` must import `relationship.dart` even though `character_version.dart` already does. When a generator run starts failing on a model, check direct imports first.
- New entity types: add an enum value in `lib/core/models/entity_type.dart` (`collectionName` values are immutable once deployed), make the model implement `StoredEntity`, and add a codec + registry entry in `lib/data/local/entity_codecs.dart`.
- Codegen deps (`build_runner`, `freezed`, `json_serializable`, `drift_dev`) currently live in `dependencies` instead of `dev_dependencies` — known inconsistency, not worth "fixing" casually.

## Architecture decisions (do not reverse silently)

- **Encryption is at the sync boundary, not at rest.** The local DB holds plaintext (enables FTS5 search); sensitive fields are AES-256-GCM encrypted only before upload. UI/repos never talk to Firebase directly — repositories mediate.
- Master key lives in `flutter_secure_storage` (Android Keystore / Windows DPAPI). Recovery codes start with `VK-` (base32 + FNV-1a checksum). See `lib/core/encryption/`.
- **Character versioning = inherit + override.** A version stores only differing fields; `null`/empty = inherit from the base. `Character.resolve(CharacterVersion)` produces the merged snapshot.
- **Relationships are directional and stored once** on the owning character; the reverse edge is derived via `RelationshipType.inverse` — never mirror-duplicate them.
- Riverpod 3 API: use `hasError`/`value`, not `isError`/`valueOrNull`. `flutter pub add flutter_riverpod` resolves to 2.x; pin `^3.0.0` explicitly if upgrading.

## Platform / build quirks

- `android/gradle.properties` contains `kotlin.incremental=false` + `kotlin.compiler.execution.strategy=in-process`. This is a required workaround for Kotlin daemon incremental-cache corruption on Windows (`Could not close incremental caches ...`). Don't remove it. If the error recurs, `./android/gradlew.bat --stop` then `flutter clean` and rebuild.
- Firebase is already configured (`firebase.json`, `lib/firebase_options.dart`, `android/app/google-services.json`). `main.dart` initializes it via `DefaultFirebaseOptions.currentPlatform`. No flutterfire CLI step needed for normal development.

## Testing

- `test/support/fakes.dart` provides `InMemoryKeyStorage`; widget tests must override `keyStorageProvider` with it (real secure storage throws `MissingPluginException` in tests).
- Widget tests pump `VerseKeeperApp` inside `ProviderScope` with overrides — Firebase is **not** initialized in tests, so nothing under test may require it.
- `test/support/app_harness.dart` provides `seededDatabase(...)`, `buildTestApp(...)` (overrides `databaseProvider` + `goRouterProvider` so a test can start at any route) and `unmountTestApp(...)`. **Drift schedules a `Timer.run` when a stream is cancelled**; end any widget test that reads drift streams with `unmountTestApp(tester)` to fire it, otherwise the "Timer is still pending" invariant fails.
- Encryption/base32/model tests are pure Dart; run anywhere without platform setup.
- DB tests use `AppDatabase.forTesting()` (in-memory). `package:sqlite3` v3 bundles the native library via Dart native assets, so no extra setup is needed — but the app's `databaseProvider` must be overridden in any widget test that touches the DB.
