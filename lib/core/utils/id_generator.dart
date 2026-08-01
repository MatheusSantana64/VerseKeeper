import 'package:uuid/uuid.dart';

/// Generates stable unique identifiers for entities.
///
/// Abstracted so repositories and tests can substitute deterministic ids.
abstract interface class IdGenerator {
  String newId();
}

/// Production implementation: random v4 UUIDs.
class UuidIdGenerator implements IdGenerator {
  const UuidIdGenerator();

  static const Uuid _uuid = Uuid();

  @override
  String newId() => _uuid.v4();
}
