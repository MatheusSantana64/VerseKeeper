// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entities_dao.dart';

// ignore_for_file: type=lint
mixin _$EntitiesDaoMixin on DatabaseAccessor<AppDatabase> {
  $EntitiesTable get entities => attachedDatabase.entities;
  EntitiesDaoManager get managers => EntitiesDaoManager(this);
}

class EntitiesDaoManager {
  final _$EntitiesDaoMixin _db;
  EntitiesDaoManager(this._db);
  $$EntitiesTableTableManager get entities =>
      $$EntitiesTableTableManager(_db.attachedDatabase, _db.entities);
}
