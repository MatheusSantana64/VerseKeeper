# AGENTS.md

VerseKeeper is a Flutter app (Windows + Android targets) for worldbuilding with reusable characters. Clean architecture: `lib/core` (pure Dart: models, encryption, utils), `lib/data/local` (drift DB + DAOs), `lib/data/repositories` (feature-facing `EntityRepository<T>` interface + local impl), `lib/features` (Riverpod UI), `lib/shared` (theme). `lib/data/remote` + `lib/data/sync` are **planned but do not exist yet** — do not assume them. Planned stack: drift (local SQLite, exists), Firestore + Storage (sync backend), go_router (declared in deps but not yet wired).

## Repositories

- Features depend on typed `EntityRepository<T>` providers from `lib/data/repositories/repository_providers.dart` (`characterRepositoryProvider`, ...) and on `searchRepositoryProvider` — never on the drift DAO directly. The interface is sync-agnostic; the future sync engine will be wired behind it without changing feature code.
- Cross-entity FTS5 search is separate (`SearchRepository`) because it spans all entity types.

## Local storage (drift document-store)

- One `entities` table holds every entity as a JSON blob (`data`) plus denormalized `name`, `type`, timestamps, and a `deleted` tombstone. Nested structures (relationships, story appearances, images) live inside the JSON — do not add per-entity or join tables.
- Each entity type has a codec in `lib/data/local/entity_codecs.dart` (registered in the `entityCodecs` map) that provides fromJson/name/searchText. New entity types need: enum value in `entity_type.dart`, a model implementing `StoredEntity`, a codec + registry entry.
- Search uses a raw-SQL FTS5 virtual table (`entity_search`, created in `MigrationStrategy.onCreate`; drift has no FTS5 DSL). DAO mutations must keep the FTS row in sync.
- Models implement `StoredEntity` (`id`, `createdAt`, `updatedAt`, `entityType`, `toJson`); each also declares `EntityType get entityType` and needs `const X._();` for freezed.

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
- Encryption/base32/model tests are pure Dart; run anywhere without platform setup.
- DB tests use `AppDatabase.forTesting()` (in-memory). `package:sqlite3` v3 bundles the native library via Dart native assets, so no extra setup is needed — but the app's `databaseProvider` must be overridden in any widget test that touches the DB.
